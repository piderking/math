// #html.elem("div", attrs: (class: "equation"))[
//   This text will be inside a red div in the HTML output.
// ]
// //https://unpkg.com/tex2typst@0.3.0/dist/tex2typst.min.js
// #html.elem("script", attrs: (src: "https://unpkg.com/tex2typst@0.3.0/dist/tex2typst.min.js",))
// #html.elem("script", attrs: (src: "https://legendary-cod-94x7rqvjpjq295pj-5500.app.github.dev/script.js", defer: ""))

// Define a custom function to handle equations.
#let eq(raw-text) = {
  context {
    // Check if the target is HTML.
    if target() == "html" {
      // Use the raw text in the 'alt' attribute.
      // Use eval() to render the raw text as a math equation inside html.frame.
      html.elem("div", attrs: (class: "equation", data-latex: raw-text, data-typ: raw-text))[
        #html.frame(eval(raw-text, mode: "math"))
      ]
    } else {
      // For other targets (like PDF), render the equation normally.
      eval(raw-text, mode: "math")
    }
  }
}


#eq("sqrt(1 / 2)")

#context {
if target() == "html"{
  html.elem("link", attrs: (rel: "stylesheet", href: "style.css"))[]
  html.elem("script", attrs: (src: "https://cdn.jsdelivr.net/npm/tex2typst@0.3.0/dist/tex2typst.min.js"))[]
  html.elem("script", attrs: (src: "script.js"))[]
}
}