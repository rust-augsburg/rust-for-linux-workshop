#import "@preview/touying:0.6.1": *
#import "@preview/tiaoma:0.3.0"
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
    background: image("img/background.svg"),
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

= Welcome Rustaceans!

#image("img/rustacean-flat-happy.png")

== Rust Meetup Augsburg

- GitHub: #link("https://rust-augsburg.github.io/meetup/")
- Matrix: #link("https://matrix.to/#/#rust-augsburg:matrix.org")[\#rust-augsburg:matrix.org]

#let meetup_url = "https://rust-augsburg.github.io/meetup/Meetup_16.html"

#align(center,
  tiaoma.qrcode(meetup_url, options: (scale: 5.0, fg-color: white, bg-color: black.transparentize(100%)))
)

== Augsburg Rust Meetup #16

Stadtbücherei Augsburg

Ernst-Reuter-Platz 1, Augsburg

#v(0.2em)

=== Nächster Termin: *27. Nov. 2025 17:00*

#v(0.3em)
- *17:00* – Willkommen und Vorstellung
- *17:30* – Oxidizing Step by Step – #link("https://github.com/sirhcel")[Christian Meusel]
- *18:30* – Allgemeine Themen

== Workshop Agenda

- Freitag 20.11.
  - 16:30 Rust and Kernel Intro
  - 20:00 Abendessen Unikum

- Samstag 21.11.
  - 09:00 Einlass (evt. Kernel lokal bauen)
  - 10:00 Kernel Training
  - 12:00 Mittag Essen
  - 13:00 Kernel Hacking
  - 16:00 Offizielles Ende

#title-slide[
= #underline("Rust Linux Driver Workshop", offset: 0.5mm, stroke: 0.01mm)
#text(style: "italic", "Day 1 - Introduction")
#set align(center)
#image("img/rust-linux.png", width: 10em)
]

= Introduction

== WLAN

#align(center,
tiaoma.qrcode("WIFI:S:Rust_at_Tuxedo;T:SAE;P:9hM22LxkT;;", options: (scale: 7.0, fg-color: white, bg-color: black.transparentize(100%)))
)

== Main repository

#align(center,
tiaoma.qrcode("https://github.com/rust-augsburg/rust-for-linux-workshop", options: (scale: 6.0, fg-color: white, bg-color: black.transparentize(100%)))
)

== Why Rust?

- Low-level efficiency
- High-level ergonomics
- Correctness
- Defaults
- Modern tooling

== What makes Rust special?

- Automatic memory management without GC
- No race-conditions, use-after-free, buffer overflows, ...
- Zero-cost abstractions
- Explicitness

== What makes Rust special? - Explicitness

- Error handling
- Types:
  - No implicit conversions
  - Matching and enumerations
  - No implicit copies of data structures

= History

== Rust

- 2006: Personal project of Graydon Hoare
- 2009: Sponsored by Mozilla
- 2015: Rust 1.0
- 2021: Rust foundation

== Recent advances

- git (with version 3.0)
- GNOME
- KDE
- Cosmic DE
- apt
- CPython
- ...

= Tooling

== Cargo

```sh
# Create a new binary project named 'my_project'
cargo new my_project
cd my_project
# Compile the project
cargo build
# Compile and run the project
cargo run
```

== Cargo project structure

```
├── Cargo.lock
├── Cargo.toml
└── src
    └── main.rs
```

== Common commands

```sh
cargo add some-depencency
cargo test
cargo doc
cargo clippy
```

== Hello world

```rust
fn main() {
    println!("Hello, world!");
}
```

= Types and mutability
== Let's explore...

#slide(repeat: 3, self => [
  #let (uncover, only, alternatives) = utils.methods(self)

  #align(center + horizon,
  alternatives[
    ```rust
    let my_value = 1;


    ```
  ][
    ```rust
    let my_value = 1;
    let my_value: i32 = 1;

    ```
  ][
    ```rust
    let my_value = 1;
    let my_value: i32 = 1;
    let my_value = 1_i32;
    ```
  ])
  #v(1em)
])

== Mutability

#slide(repeat: 3, self => [
  #let (uncover, only, alternatives) = utils.methods(self)

  #align(center + horizon,
  alternatives[
    ```rust
    let my_value = 1;
    my_value = 2;
    ```
  ][
    ```rust
    let my_value = 1;
    my_value = 2; // Error!
    ```
  ][
    ```rust
    let mut my_value = 1;
    my_value = 2; // Works
    ```
  ])
  #v(1em)
])


= Ownership
== Let's explore...

#slide(repeat: 6, self => [
  #let (uncover, only, alternatives) = utils.methods(self)

  #align(center + horizon,
  alternatives[
    ```rust
    let michael = 1;
    ```
  ][
    ```rust
    let aaron = michael;
    ```
  ][
    ```rust
    let aaron = michael; // Both store 1
    ```
  ][
    ```rust
    let michael = String::from("Michael");
    ```
  ][
    ```rust
    let aaron = michael;   // Ownership was transferred
    ```
  ][
    ```rust
    let aaron = michael;   // Ownership was transferred
    do_something(michael); // Error!
    ```
  ])
  #v(1em)
])

== Why?

== Let's explore...

#slide(repeat: 2, self => [
  #let (uncover, only, alternatives) = utils.methods(self)

  #align(center + horizon,
  alternatives[
    ```rust
    let michael = String::from("Michael");
    ```
  ][
    ```rust
    let michael = String::from("Michael");
    do_something(michael);
    println!("{michael}"); // Error!
    ```
  ])
  #v(1em)
])

== Advantages for single-threaded code

```rust
fn main() {
    let mut v = vec![1, 2, 3];
    let first = &v[0]; // shared borrow occurs here
    v.push(4); // exclusive borrow occurs here
    // shared borrow later used here:
    println!("{:?} {}", v, first);
}
```

#rust_for_c

== Advantages for single-threaded code

```rust
// Tries to return a shared reference to a String
fn dangle() -> &String {
    let s = String::from("hello");
    &s // Return a reference to s
} // s goes out of scope and is dropped here.
  // The returned reference would point to invalid memory!
```

#rust_for_c

== Exercises

```rust
```
