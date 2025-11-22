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

= Welcome back Rustaceans!

#image("img/rustacean-flat-happy.png")

== Workshop Agenda

- Samstag 21.11.
  - 09:00 Einlass (evt. Kernel lokal bauen)
  - 10:00 Kernel Training
  - 12:00 Mittag Essen
  - 13:00 Kernel Hacking
  - 16:00 Offizielles Ende
== Deb kernel packages

#let url = "https://cloud.tuxedo.de/index.php/s/cgMd53op82sAgoK"
#align(center,
  tiaoma.qrcode(url, options: (scale: 5.0, fg-color: white, bg-color: black.transparentize(100%)))
)
#url

Password: rust_linux

#title-slide[
= #underline("Rust Linux Driver Workshop", offset: 0.5mm, stroke: 0.01mm)
#text(style: "italic", "Day 2 - Into the kernel!")
#set align(center)
#image("img/rust-linux.png", width: 10em)
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

= The kernel Rust dialect

== no_std

== no_std

#align(center + horizon,
  [No `std` in the Kernel :(]
)
#v(3em)

== no_std

#align(center + horizon,
  [But there's `core` and the `kernel` crate! 🎉]
)
#v(3em)

== Pin init

```rust
// That's how we do it normally
struct Foo {
    a: Mutex<usize>,
    b: u32,
}

let foo = Foo {
    a: Mutex::new(42),
    b: 24,
};
```

== Pin init

```rust
#[pin_data]
struct Foo {
    #[pin]
    a: Mutex<usize>,
    b: u32,
}

let foo = pin_init!(Foo {
    a <- Mutex::new(42),
    b: 24,
});
```

== Traits

```c
struct file_operations {
  	ssize_t (*read) (struct file *, ...);
  	ssize_t (*write) (struct file *, ...);
    // Further methods omitted
}
```

== Traits

```rust
trait FileOperations {
   	fn read(file: *mut File, ...) -> usize;
  	fn write(file: *mut File, ...) -> usize;
    // Further methods omitted
}
```

== Traits

```c
struct file_operations ops = {
   	.read: NULL,
  	.write: NULL,
    // Further methods omitted
}
```

== Traits

```rust
trait FileOperations {
   	fn read(file: *mut file, ...) -> usize { 0 }
  	fn write(file: *mut file, ...) -> usize { 0 }
    // Further methods omitted
}
```

== Traits

```rust
#[vtable]
trait FileOperations {
    fn read(file: *mut file, ...) -> usize {
        build_error!(VTABLE_DEFAULT_ERROR)
    }

   	fn write(file: *mut file, ...) -> usize {
        build_error!(VTABLE_DEFAULT_ERROR)
    }
}
```

== Traits

```rust
struct Foo;

// Implements the `#[vtable]` trait
#[vtable]
impl FileOperations for Foo {
    fn read(file: *mut File, ...) -> usize {
        // Some code
    }
}
```
