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
    
    let txt = raw-text
      .replace("ddx", "d/(d x)")
      .replace("ddy", "d/(d y)")
      .replace("dxdy", "(d x)/(d y)")
      .replace("dydx", "(d y)/(d x)")
      .replace("dudx", "(d u)/(d x)")
    

      if target() == "html" {
      // Use the raw text in the 'alt' attribute.
      // Use eval() to render the raw text as a math equation inside html.frame.
      let math = eval(txt, mode: "math")
      html.elem("div", attrs: (class: "equation", data-latex: txt, data-typ: txt))[
        #html.frame(text(fill:white, size:20pt, [#math]))
      ]
    } else {
      // For other targets (like PDF), render the equation normally.
      eval(txt, mode: "math")
    }
  }
}

#let graph_container(..graph_content, height: "40vh", width: "65vw" ) = {
  context {
        if target() == "html" {
      html.elem("div", attrs: (style: "padding-top: 20px; padding-bottom: 20px; width:" + width + "; height:" + height +  ";", class: "graph",))[
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

#let week(week, content) = {
  return html.elem("div", attrs: (class: "container"))[
      = Week #week
      #content
  ]
 
}
#let tmv( content ) = {
  return [
    == Teach Me Video
    #content
  ]
}
#let gpa( content ) = {
  return [
    == Group Assignment
    #content
  ]
}
#let ps(title, content) = {
  return [
    == Problem Set: #title

    #content

  ]
}

#let problem(title, definition) = {
  return [
    #html.elem("div", attrs: (class: "box problem"))[ 
      === Problem: #title
      #definition
    ]
    

  ]
}
#let step(title, definition) = {
  return [
    #html.elem("div", attrs: (class: "box step"))[ 
      ==== Step: #title
      #definition
    ]
    

  ]
}
#let solution(definition) = {
  return [
    #html.elem("div", attrs: (class: "box solution"))[ 
      ==== Solution:
      #definition
    ]
    

  ]
}
#let notes(title, definition) = {
  return [
    #html.elem("div", attrs: (class: "box notes"))[ 
      ==== Notes: #title
      #definition
    ]
    

  ]
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
  // all.map(h => h.body.text.replace(" ", "-")).join(".")
  // Convert heading.body (content) to plain text
  all
    .map(h => repr(text(h.body))
      .replace("[", "")
      .replace("]", "")
      .replace(" ", "-"))
    .join(".")
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




// ---------------------------------------------------------------------------------------------------------
// Problem Start
// ---------------------------------------------------------------------------------------------------------
#container[
  #toc() 
]

#week(9)[

  #ps("Section 4.4: Mean Value Theorem")[

   


    #notes("Mean Value Theorem")[
      Let F be 
      - continous over #eq("[a,b]")
      - differentiable over #eq("(a,b)")
      Then there's at least one point (c) in the interval where

      #eq("f'(c) = (f(b) - f(a))/(b-a)")
      // #graph_container(
      //   graph("f(x)")
      //   )
    ]
    #problem("Example")[
      #eq("f(x) = sqrt(x)")

    ]

    #step("Differentiate")[
      #eq("f'(x) = 1/(2sqrt(x)) [0,9]")
    ]
    #step("Mean Value Theorem")[
      There must be a point where

      #eq("f'(c) = (f(b) - f(a))/(b-a)")

      Thus we can do the follow...

      #graph_container(
        graph("f(x)=sqrt(x)"),
        graph("a=0"),
        graph("b=9"),
        graph("(f(b) - f(a))/(b-a)"),
              )
     Now its just algebra

     #eq("f'(c) = 1/3")
     #eq("1/(2sqrt(c)) = 1/3")
    ]
    
  ]



  #gpa[]

  #tmv[]


]

#week(10)[

  #ps("4.6 Limits at Infinity and Asymptotes")[
    #notes("Limits to Infinity")[

      #eq("limits(lim)_(x->oo) f(x) = L")
      Horizontal Asymptotes

      #eq("|f(x) - L| < epsilon")
      #eq("limits(lim)_(x->oo) N/x = 0")
      Epsilon Subsitute
      #eq("epsilon > 0")
      #eq("N = 1/epsilon")
      #eq("epsilon = 1/N")

    ]
    #notes("Limits at Asymptotes")[
      #eq("limits(lim)_(x->c) f(c) = oo")

    ]
    #problem("Evaluate Limit to Infinity")[

      #eq("limits(lim)_(x->oo) (4 + 5x)/(7-8x)")
    ]
    #step("Divide")[
      
      #eq("limits(lim)_(x->oo) (4/x + 5)/(7/x-8)")
    ]
    #solution[

      #eq("limits(lim)_(x->oo) =  -5/8")
    ]

  #problem("Evaluate Limit to Infinity")[

      #eq("limits(lim)_(x->oo) (11x+3)/(11x^2-10x+2)")
    ]
    #step("Divide")[
      
      #eq("limits(lim)_(x->oo) (11/x + 3/x^2)/(11-10/x+2/x^2)")
    ]
    #solution[

      #eq("limits(lim)_(x->c) =  0/11") #eq("0")
    ]


    #ps("4.7 Optimization Problems")[]

    #notes("Average Cost")[
      #eq("overline(C)(x) = C(x)/x")
    ]
    #notes("Marginal Cost")[
      #eq("C'(x)")
    ]
    #notes("To minimize")[
      Find zeros of derivative of function you're trying to minimize and then plug them into a second derivative test. if they're positive its a minima and negative is a maxima
    ]
    #problem("Cost Optimization #1")[
A box with a square base and open top must have a volume of 364500 
. We wish to find the dimensions of the box that minimize the amount of material used.

First, find a formula for the surface area of the box in terms of only 
, the length of one side of the square base.


    ]
    #step("Surface Area")[
      #eq("A(x) = x^2 + 4 * 364500/x")
    ]
    #step("Derivaitve Surface Area")[
      #eq("A'(x) = 2x + 4 * -364500/x^2")
    ]
    #step("Find Zeros")[
      When
      #eq("0 = x^3 + 2*-364500")
      #eq("x^3=2*364500")
      #eq("x=90")
    ]

    #step("Second Derivaitve Surface Area")[
      #eq("A''(x) = 2 + 8 * 364500/x^3")
    ]
    #solution[
      #eq("x=90")
    ]
    #notes("Local Minimum")[
      Since 
      #eq("A''(90) = 6") -> Concave up
      and because it's at 
      #eq("A'(90) = 0") 
      then its local minima
    ]
    #notes("Cost Function Optimization")[
      #graph_container(
        graph("C(x)=16900 + 300x + x^2"),
        graph("A(x) = C(x)/x"),
        graph("A'(x)"),
        graph("z=130"),
        graph("A(z)"),
        graph("A'(z)"),
        graph("A''(z)"),
      )
    ]
    #problem("Optimizing Volume #4 ")[
      If 1000 square centimeters of material is available to make a box with a square base and an open top, find the largest possible volume of the box.
    ]
    #notes("Equations")[
      #eq("V = x^2 * y")
      #eq("S=x^2 + 4x y = 1300")
    ]
    #step("Solve for Y")[
        #eq("1300 - x^2 = 4x y")
        #eq("y= 1300/4x - x/4")
    ]
    #step("Subsitute Into Volume Equation")[
        #eq("V = x^2 * (325/x - x/4)")
    ]

    #step("Derivative and Maxima")[
      #eq("V=325x-x^3/4")
      #eq("V' = 325 - 3x^2/4 ")
      #eq("432 = x^2")
      
      Zeros of V'

      #eq("x=+-20.81666")

      V'' of Zeros
      #eq("-+31.22499")

      Thus first is maxima and therefore will result in the highest Volume


    
    ]
    #solution[
      #eq("V(20.81666)=4510.27633218")
    ]

    #problem("Optimizing Ladder")[
      We wish to find the length of the shortest ladder that will reach from the ground over the fence to the wall of the building.
      Ladder: 9ft
      Parallel from building 3ft away
    ]
    #step("Equation of Ladder")[
      #eq("L(theta)=9csc(theta)+3sec(theta)")
    ]
    #step("Minimize")[
      Find Derivative
      #eq("L'(theta)=-9cot(theta)csc(theta) + 3 tan(theta)sec(theta)")
      Find Zeros (Only Accute Angles)
      #eq("L'(theta) = 0") #eq("[0, pi/2)")#eq("theta = 0.96454") 
      Second Derivative Test (Simplified Thru Desmos)
      #eq("L''(0.96454) > 0") 
    ]
    #solution[
      Thus, it is the local minima
      #eq("L(0.96454) = 16.2167961823 ")
    ]

    #problem("Maximize Area")[
    A rectangle is inscribed with its base on the x-axis and its upper corners on the parabola.
    #eq("y=-x^2+3")
    What are the dimensions of such a rectangle with the greatest possible area?
    ]
    #step("Equation")[
      Rectangle Area 
      #eq("A(x)= x y")

      Equation
      #eq("y=3-x^2")

      Rectange Area
      #eq("A(x) = -x^3 + 3x")


    ]
    #step("Maxima")[
      Find Derivative  
      #eq("A'(x) = -3x^2 + 3")
      Find Zeros of Derivaitve
      #eq("-3x^2 + 3 = 0")
      #eq("-3x^2 = -3")
      #eq("x^2 = 1")
      #eq("x = +-1")
      Plug into Second Derivative
      #eq("A''(x) = -6x")
      #eq("A''(1) = -6 < 0")
      Thus we have our maxima
    ]
    #solution([
      The corner are at #eq("(1, 2)")#eq("(-1, 2)")
      Thus the width is 2 and the height is 2
    ])
  ]
  #gpa[
    #problem("Graph the following with the given properties")[
      First Derivatives
      #eq("f'(-1) = f'(3) = 0 ") #eq("f'(x) = 1 \"if\" x < -2 ")
      #eq("f'(x) > 0 \"if\" -1 < x < -2")
      #eq("f'(x) < 0 \"if\" -2 < x < -1")
      #eq("f'(x) < 0 \"if\" 1 < x != 3")
      Second Derivatives
      #eq("f''(x) > 0 \"if\" -2 < x < 1")
      #eq("f''(x) > 0 \"if\" 1 < x < 3")
      #eq("f''(x) < 3 \"if\" x > 3")

      Asymptotes
      #eq("limits(lim)_(x->1^-) f'(x) = oo")

      #eq("limits(lim)_(x->1^+) f'(x) = -oo")

    ]
  ]
  


]
// #container([
// = Week 9
// == Teach Me Video
// #eq("f(x) = (x*2)/45 * ln(x)^{2}")
// ])

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
