    \version "2.18.2"

\header {
  title = "(<>)"
  subtitle = ""
  composer = "Gabriel Fernández Cueva"
}

melody = \relative c'' {
  \tempo 4 = (<>)
  \clef "treble_8"
  \key (<>) \(<>)
  \time (<>)

  (<>)
  \bar "|."
}

text = \lyricmode {
  (<>)
}

\score{
  <<
    \new Voice = "one" {
      \melody
    }
    \new Lyrics \lyricsto "one" \text
  >>
  \layout { }
  \midi { }
}
