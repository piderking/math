// #html.elem("div", attrs: (class: "equation"))[
//   This text will be inside a red div in the HTML output.
// ]
// //https://unpkg.com/tex2typst@0.3.0/dist/tex2typst.min.js
// #html.elem("script", attrs: (src: "https://unpkg.com/tex2typst@0.3.0/dist/tex2typst.min.js",))
// #html.elem("script", attrs: (src: "https://legendary-cod-94x7rqvjpjq295pj-5500.app.github.dev/script.js", defer: ""))

// Define a custom function to andle equations.
#let eq(raw-text) = {
  context {
    // Check if the target is HTML.
    if target() == "html" {
      // Use the raw text in the 'alt' attribute.
      // Use eval() to render the raw text as a math equation inside html.frame.
      let math = eval(raw-text, mode: "math")
      html.elem("div", attrs: (class: "equation", data-latex: raw-text, data-typ: raw-text))[
        #html.frame(text(fill:white, size:20pt, [#math]))
      ]
    } else {
      // For other targets (like PDF), render the equation normally.
      eval(raw-text, mode: "math")
    }
  }
}

#let graph_container(..graph_content, height: "400px", width: "700px" ) = {
  context {
        if target() == "html" {
      html.elem("div", attrs: (style: "width:" + width + "; height:" + height +  ";", class: "graph",))[
        #for value in graph_content.pos() {
          
          if value.at("eq", default: "") != "" { 
            html.elem("div", attrs:(equation: value.at("eq")))
          }
          if value.at("point", default: "") != ""{
            html.elem("div", attrs:(point: value.at("point")))
          }
        }
      ]}
  }
 
}

#let point(point, options: (), ) = {
  // Do some pre-setup here
  return (
    point: point,
    options: options
  )
 }
#let graph(equation, options: (), ) = {
  // Do some pre-setup here
  return (
    eq: equation,
    options: options
  )
 }
#let container(body) = {
  return html.elem("div", attrs: (class: "container"), body)
}
// ---------------------------
// HTML Content
// ------------------------------------
// Function to generate hierarchical ID
// ------------------------------------
#let full_id = (heading, prev_headings) => {
  // prev_headings is already a list of headings (computed inside context)
  let parents = prev_headings.filter(h => h.level < heading.level)
  let all = (..parents, heading) 
  all.map(h => h.body.text.replace(" ", "-")).join(".")
}

// Level 1 example
#show heading.where(level: 1): it => {
  context {
    // Compute prev_headings inside context (here() is valid here)
    let prev_headings = query(selector(heading).before(here()))
    
    // Compute ID string
    let id_str = full_id(it, prev_headings)
    
    html.elem(
      "h1",
      attrs: (id: id_str),
     it.body 
    )
  }
}

// Level 2 example
#show heading.where(level: 2): it => {
  context {
    // Compute prev_headings inside context (here() is valid here)
    let prev_headings = query(selector(heading).before(here()))
    
    // Compute ID string
    let id_str = full_id(it, prev_headings)
    
    html.elem(
      "h2",
      attrs: (id: id_str),
     it.body 
    )
  }
}
// Level 3 example
#show heading.where(level: 3): it => {
  context {
    // Compute prev_headings inside context (here() is valid here)
    let prev_headings = query(selector(heading).before(here()))
    
    // Compute ID string
    let id_str = full_id(it, prev_headings)
    
    html.elem(
      "h3",
      attrs: (id: id_str),
     it.body 
    )
  }
}
// Level 4 example
#show heading.where(level: 4): it => {
  context {
    // Compute prev_headings inside context (here() is valid here)
    let prev_headings = query(selector(heading).before(here()))
    
    // Compute ID string
    let id_str = full_id(it, prev_headings)
    
    html.elem(
      "h4",
      attrs: (id: id_str),
     it.body 
    )
  }
}
// --------------------------------
// Title Page
#html.elem("div", attrs: (class: "title-page"))[
  #html.elem("h1")[Calc 400]
  #html.elem("h2")[By: Peter Bowman]
]

#let url_path(path: "#toc") = {
  return "main.html"+path
}

#let toc = () => {
  context {
    // Title for the TOC
    html.elem("h2", [Table of Contents])
    
    let li_items = ()

    // Keep a running list of previous headings for hierarchy
    let prev_headings = ()

    // Loop over all headings in document
    for heading in query(selector(heading)) {
      // Compute hierarchical ID based on previously seen headings
      let id_str = full_id(heading, prev_headings)
      
      // Compute indent (in em) based on heading level
      let indent_em = (heading.level - 1) * 1.5

      li_items.push(
        html.elem("li", attrs: (style: "margin-left: " + str(indent_em) + "em;"), [
          #html.elem("a", attrs: (href: url_path(path: "#" + id_str)), heading.body)
        ])
      ) 

      // Add this heading to prev_headings for the next iteration
      prev_headings.push(heading)
    }

    // Wrap all <li> items in a <ul>
    html.elem("ul", attrs: (class: "toc", id: "toc"), [#for li in li_items {
      li
    }])
  }
}

#let link_to_toc() = {
  html.elem("a", attrs:(href: url_path(), class: "toc_link"))
}

#container[
  #toc()
]

#container([
= Week 9
== Teach Me Video
#eq("f(x) = (x*2)/45 * ln(x)^{2}")
])

 // #graph_container(
 //   graph("f(x)=x"),
 //   graph("f(1)")
 // )

#context {
if target() == "html"{
  html.elem("link", attrs: (rel: "stylesheet", href: "style.css"))[]
  html.elem("script", attrs: (src: "https://cdn.jsdelivr.net/npm/tex2typst@0.3.0/dist/tex2typst.min.js"))[]
  html.elem("script", attrs: (src: "https://www.desmos.com/api/v1.11/calculator.js?apiKey=ea329ee047324c21861ea29b652fe109"))[]
  html.elem("script", attrs: (src: "script.js"))[]
}
}
