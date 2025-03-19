// init
a = new Set;

// run manually and scroll to load next songs
start = a.size
list = document.querySelectorAll(".JUa6JJNj7R_Y3i4P8YUX [role=row]").forEach(el => {
  a.add(`${el.querySelector('a').text} - ${el.querySelector('span a').text}`);
  el.scrollIntoView()
})
console.log(`added ${a.size - start}, total ${a.size}`);

// output
[...a].join("\n");
