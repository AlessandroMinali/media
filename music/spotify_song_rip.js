Array.from(
  document.querySelectorAll(
    'div[data-testid="playlist-tracklist"] div[role="row"][aria-selected="false"]'
  )
).map(x => x.innerText.split("\n\n")[1].replaceAll("\n", " ")).join("\n");