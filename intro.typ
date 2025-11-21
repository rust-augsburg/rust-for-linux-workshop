#import "@preview/cades:0.3.1": qr-code


#stack(
  dir: ltr,
  spacing: 1em,
  [
    #image("./img/MeetupLogo.svg", width: 2cm, alt: "The Rust Meetup Logo")
  ],
  [
    #align(center)[
      = Rust Augsburg
      #link("https://rust-augsburg.github.io/meetup/")
      
      Matrix: #link("https://matrix.to/#/#rust-augsburg:matrix.org")[\#rust-augsburg:matrix.org]      
    ]  
  ]
)

#stack(
  dir: ltr,
  spacing: 1em,
  [

#let meetup_url = "https://rust-augsburg.github.io/meetup/Meetup_16.html"

#qr-code(meetup_url, width: 6cm)
  ],
  [
= Augsburg Rust Meetup #16

== Wo

Stadtbücherei Augsburg

Ernst-Reuter-Platz 1 · Augsburg, BY

== Nächster Termin: *27. Nov. 2025 17:00*

== Agenda

- *17:00* – Willkommen und Vorstellung  
- *17:30* – Oxidizing Step by Step – #link("https://github.com/sirhcel")[Christian Meusel]  
- *18:30* – Allgemeine Themen
  ],
)


= Workshop Agenda

== Freitag 20.11.

=== 16:30 Rust and Kernel Intro

=== 20:00 Abendessen Unikum

== Samstag 21.11.

=== 09:00 Einlass (evt. Kernel lokal bauen)

=== 10:00 Kernel Training

=== 12:00 Mittag Essen

=== 13:00 Kernel Hacking

=== 16:00 Offizielles Ende
