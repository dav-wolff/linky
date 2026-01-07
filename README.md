# linky

Linky is a personal project for a website linking to profiles on several social media platforms.
It is focused on aesthetics and a fast first site load. The entire site excluding high resolution
pictures is less than 10 kilobytes and loads very quickly.

## Features

- Responsive design fitting portrait and landscape mobile as well as desktop layouts
- Always fits exactly on the screen, no scrolling
- Wave animation and particles in pure CSS + HTML
- Pretty opening animations on site load
- Subset font for reduced size
- Inline styles, including the font, to display the entire site after the first request
- Embedded [ThumbHash](https://evanw.github.io/thumbhash/) previews to avoid ugly blank spaces whilst the images are loading
- Minified CSS and JS for faster site load
- Pre-compressed brotli to avoid on-the-fly encoding

## Technical considerations

### Embedding trade-off

Embedding styles and scripts is often avoided so that they can be cached and shared between sites.
Linky is in the unique position of being a single site that is usually only visited once.
Therefore it makes sense to take some more drastic measures to optimize the initial site load.  
By embedding the style and font, the proper version of the page can be displayed after a single
request. This not only reduces the time to load the page, but also avoids flashes of unstyled
content.  
In contrast, the pictures are lazily loaded. This allows the browser to only fetch the correct
picture and size needed for the current layout.

### ThumbHash

[ThumbHash](https://evanw.github.io/thumbhash/) is used to embed previews of the pictures.
This is done with a script that sets the parsed ThumbHash as the background image of the pictures,
to be displayed in the (hopefully very short) time whilst they are still loading. This avoids ugly
flashes of blank spaces in the positions of the pictures before they have loaded.
The ThumbHashes and the functions to display them are embedded in the HTML. The ThumbHashes themselves
are only a few bytes. The script is minimized before being inlined. Overall, this only adds about a
kilobyte to the compressed size, which is insignificant compared to the size of the rest of the site.

### Placeholders

The source code uses placeholders for pictures, links, and the name. This is done for reasons of privacy
and flexibility of what to insert. A script is included to automatically replace all placeholders with
the values given as environment variables.

## Screenshots

**Note:** The screenshots use a placeholder picture. The portrait layout looks much better with
an actual banner instead of a stretched out avatar.

### Mobile portrait layout

![Demo site in mobile portrait layout](/screenshots/portrait.png)

### Mobile landscape layout

![Demo site in mobile landscaoe layout](/screenshots/landscape.png)

### Desktop layout

![Demo site in desktop layout](/screenshots/desktop.png)

Placeholder avatar source: https://commons.wikimedia.org/wiki/File:Default-avatar.jpg
