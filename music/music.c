#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUF_SIZE 256
#define READ_BUF 4096

int str_len(const char *str) {
  int i = 0;
  for(; i < READ_BUF; ++i) {
    if (str[i] == '\0') { break; }
  }
  return i;
}

int main() {
  int count = 0, c = 0;
  char buf[BUF_SIZE], buf2[READ_BUF];

  // list manipulation
  FILE *list_r = fopen("list.txt", "r");
  FILE *list_w = fopen("list_tmp.txt", "w");

  fgets(buf, BUF_SIZE, list_r);
  for(; count < BUF_SIZE; ++count) {
    if (buf[count] == '\0') { break; }
  }
  while((c = fread(buf2, 1, READ_BUF, list_r))) {
    fwrite(buf2, 1, c, list_w);
  }

  // done manipulation
  FILE *done_r = fopen("done.txt", "r");
  FILE *done_w = fopen("done_tmp.txt", "wb");

  int result;
  while(fgets(buf2, READ_BUF, done_r)) {
    result = strncasecmp(buf, buf2, count);
    if (result < 0) {
      fwrite(buf, 1, count, done_w);
      fwrite(buf2, 1, str_len(buf2), done_w);

      // link manipulation
      for(int i = 0; i < BUF_SIZE; ++i) {
        switch(buf[i]) {
          case('\n'): {
            buf[i] = '\0';
            break;
          }
          case(' '): {
            buf[i] = '+';
            break;
          }
          case('&'): {
            buf[i] = '+';
          }
        }
      }
      snprintf(buf2, BUF_SIZE, "open \"https://duckduckgo.com/?q=%s+!ytm\" &", buf);
      system(buf2);

      break ;
    } else if (result == 0) {
      fwrite(buf2, 1, str_len(buf2), done_w);
      printf("DUPLICATE\n");
      break;
    }
    fwrite(buf2, 1, str_len(buf2), done_w);
  }
  while(fgets(buf2, READ_BUF, done_r)) {
    fwrite(buf2, 1, str_len(buf2), done_w);
  }

  fclose(list_r);
  fclose(list_w);
  fclose(done_r);
  fclose(done_w);
  remove("list.txt");
  rename("list_tmp.txt", "list.txt");
  remove("done.txt");
  rename("done_tmp.txt", "done.txt");

  return 0;
}
