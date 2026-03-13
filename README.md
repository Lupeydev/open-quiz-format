# Open Quiz Format

The Open Quiz Format (OQF) is a markup language for creating multiple choice
quizzes. It attempts to be as simple to use as possible for anyone to use.

## Format

A `.oqf` file can be made in any text editor and has an extremely simple
format.

### Header

An OQF File header consists of the following line

```oqf
**OQF*

```

### Questions & Answers

Questions and answers are formatted with the following syntax:

```oqf
:Question (can include :, !, ;, and =)
!Incorrect answers are marked with a ! and not a =
=Correct answers are marked with a = and not a !
=Multiple correct answers can be selected at the same time
!Questions can have as many questions as you want
=Questions end with a semi colon character;
```

## FAQ

### Where can I use this?

Right now, the only place that I have a parser for is
[Typst](https://typst.app), but I hope to write a parser in Go sometime in the
future. I might even write one in rust if I feel like it.

### I want to use this in my project!

Awesome! If there's a library for your preferred language, great! If not,
take a look at [oqf.typ](./oqf.typ) for a reference implementation.

### Why is the reference implementation written with Typst?

I came up with this idea in school, so I had no access to compilers when coming
up with the idea. I did, however, have access to Typst.

### What programs support opening `.oqf` files

Any program that can edit data (Notepad, VSCode, Neovim, etc)

### What inspired this?

I was looking into how [Kahoot](https://kahoot.com) handles importing
questions. It turns out, they have you use a template `.xlsx` to format
everything properly. Upon first glance, this doesn't seem *too* bad, but if you
look into what a `.xlsx` file is, you start to realize there's a ton of
unnecesary data being transferred. It just seemed like an unoptimal way of doing
things. So I decided to look into creating my own format for making quizzes.
Next thing you know I've got something of an **Open Quiz Format** on my hands.

### Why does something like this need to exist?

Well, it doesn't *need* to exist. [Kahoot](https://kahoot.com) has a way to
import a list of questions and associated answers. However, as stated in the
previous FAQ, it is VERY inefficient.

### Okay, but how does it actually compare to Kahoot's method?

Kahoot's sample spreadsheet (which kindly enough contains a starter question)
takes up 27.2 kB according to nushell's ls. This same exact\* quiz rewritten with
OQF (available at [sample.oqf](./sample.oqf)) takes up 121 B according to
nushell's ls. That's almost a 225x size reduction. This makes a lot of sense
when you consider the fact that a spreadsheet also has to carry info about
styling, images, grouped cells, and probabl more that I'm missing.

\*Technically, the quiz is not exact, as it cannot store time information
(yet...)
