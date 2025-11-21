#import "@preview/touying:0.6.1": *
#import themes.simple: *

#set text(
    font: "IBM Plex Sans",
    fill: rgb(255, 255, 255),
    lang: "en",
    ligatures: true,
)

#show: simple-theme.with(
  aspect-ratio: "16-9",
  // footer: [Rust Linux Driver - 21.11.2025],
)

#set page(
    background: image("background.svg"),
)

#set raw(theme: "dark.tmTheme")
#show raw: text.with(
    font: "JetBrains Mono",
    ligatures: true,
)

#let rust_for_c = align(right, {
  h(0.6em)
  text(size: 0.6em, fill: rgb("#999"), emph("Source: rust-for-c-programmers.com"))
})

#title-slide[
= #underline("Rust Linux Driver Workshop", offset: 0.5mm, stroke: 0.01mm)
#text(style: "italic", "Day 1 - Introduction")
#set align(center)
#image("rust-linux.png", width: 10em)
]

= Introduction

== Why Rust in the Kernel?

= History

== Linux Kernel

== Recent advances

- Nova (Nvidia)
- Tyr (A)
- Apple GPU
- Android Binder

== Are we Linux yet?

Well, it depends...

== Are we Linux yet?

- LLVM is still recommended
- Most distros build without Rust enabled
- Some production-ready drivers are already there
- Some subsystems have no abstractions yet
- Some things are still changing requently
