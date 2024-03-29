#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "../lib/ssl/_simple_ssl.h"

#define BUFFER_SIZE 4096
#define STRING_SIZE 1024
#define MAX_TRACK 32
#define MAX_LINK 256
#define MAX_NAME 128

int main(const int argc, const char *argv[]) {
  if (argc != 2 ) { printf("Provide a bcamp album url.\n"); return 1; }

  SSL* ssl = _simple_ssl_get(argv[1]);

  unsigned int len;
  unsigned int track_n = 0;
  unsigned int ref, count;
  char fname[STRING_SIZE] = { 0 };
  char tracks[MAX_TRACK][MAX_LINK] = { 0 };
  char track_names[MAX_TRACK][MAX_NAME] = { 0 };
  char buf[BUFFER_SIZE] = { 0 };
  char *ptr = buf;
  char *artist, *track_name;

  // FILE *f = fopen("test.html", "wb"); //
  do {
    len = SSL_read(ssl, buf, _SSL_DL_SIZE);
  } while(strstr(buf, "t4.bcbits") == NULL);
  ptr += len;

  while(1) {
    len = SSL_read(ssl, ptr, _SSL_DL_SIZE);

    // new chunk arrived so snip chunk size
    if (len <= 6) { ptr -= len; }

    // fwrite(ptr, len, 1, f); //
    // printf("%d\n", len); //
    if (len > 128 && strstr(ptr, "&quot;") == NULL) { break; }
    ptr += len;
  }
  SSL_shutdown(ssl);

  artist = strstr(buf, "artist&quot;:&quot;") + 19;
  ptr = strstr(artist, "&quot;");
  ptr[0] = '\0';
  ++ptr;
  printf("%s\n", artist);

  while((ptr = strstr(ptr, "https://t4.bcbits"))) {
    ref = 3;
    count = 0;
    while(1) {
      tracks[track_n][count] = *ptr;
      if (*ptr == '&') {
        if (ref == 0) { tracks[track_n][count] = '\0'; break; }
        tracks[track_n][count] = '&';
        ptr += 5;
        --ref;
      } else {
        ++ptr;
      }
      ++count;
    }

    track_name = strstr(ptr, "title") + 18;
    ptr = strstr(track_name, "&quot;");
    ptr[0] = '\0';
    strcpy(track_names[track_n], track_name);
    ++ptr;

    ++track_n;
  }
  for(int i = 0; i < MAX_TRACK; ++i) {
    if (tracks[i][0] == '\0') { break; }

    ssl = _simple_ssl_get(tracks[i]);
    snprintf(fname, STRING_SIZE, "%s - %s.mp3", artist, track_names[i]);
    _simple_ssl_file(ssl, fname);
    printf("%d. %s\n", i + 1, track_names[i]);
  }

  return 0;
}
