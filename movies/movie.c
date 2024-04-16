#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define BUFFER_SIZE 1024

int main() {
  char buf[BUFFER_SIZE];
  char search[BUFFER_SIZE];
  char c;
  char *sites[] = {
    "https://www.criterionchannel.com/search?q=",
    "http://unogs.com/search/",
    "https://thepiratebay.org/search.php?q=",
    // "https://sflix.app/browse?c=movie&m=filter&keyword=",
  };
  char *site_labels[] = { "criterion", "netflix",  "thepiratebay", "sflix", };

  for(int i=0; i < 3 ; ++i) {
    printf("Search %s? [y/n] ", site_labels[i]);
    scanf(" %c", &c);
    if (c == 'n') { continue; }

    FILE *f = fopen("./list.txt", "rb");

    while(fgets(buf, BUFFER_SIZE, f)) {
      if (buf[0] == '\n') { continue; }
      buf[strcspn(buf, "\n")] = 0;

      snprintf(search, BUFFER_SIZE, "open \"%s%s\"", sites[i], buf);
      system(search);
      usleep(1000000);
    }
    fclose(f);
  }

  return 0;
}
