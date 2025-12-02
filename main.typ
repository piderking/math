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

      .replace("dxdt", "(d x)/(d t)")
      .replace("ddx", "d/(d x)")
      .replace("ddy", "d/(d y)")
      .replace("dxdy", "(d x)/(d y)")
      .replace("dydx", "(d y)/(d x)")
      .replace("dudx", "(d u)/(d x)")
      .replace("dx", "d x")
      .replace("d u", "d u")
      .replace("d/dx", "d/(d x)")
      .replace("d/dy", "d/(d y)")
      .replace("arctan", "tan^(-1)")
      .replace("arccot", "cot^(-1)")
      .replace("arcsin", "sin^(-1)")
      .replace("arccos", "cos^(-1)")
      .replace("arccsc", "csc^(-1)")
      .replace("arcsec", "sec^(-1)")
      .replace("integral", "stretch(integral, size: #3em)" )
      .replace("!=", " eq.not ")
      .replace("sum", "limits(sum)")
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
#let local_image(file_name, height: "40vh", width: "65vw" ) = {
   context {
        if target() == "html" {
      html.elem("img", attrs: (src: "/images/"+file_name, style: "padding-top: 20px; padding-bottom: 20px; width:" + width + "; height:" + height +  ";", ))[

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
      Find the x value where it equals that over the interval [a, b]
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

    #notes("How to Evaluate Limits at Infinity")[
      To evaluate a limit at infinity the most important fact to know is that 
      #eq("limits(lim)_(x->oo) 1/x = 0")

      The goal to the solutions of these problems is to get all the terms either to
      #eq("1/x^n") or get rid of them. Most common solution is by dividing both top and bottom by x

    ]
    #problem("Evaluate Limit to Infinity with Square Root")[

      #eq("limits(lim)_(x->oo) (-5x)/sqrt(2x^2+11) ")

    ]
    #solution[

      #eq("limits(lim)_(x->oo) (-5x)/sqrt(2x^2+11) * (1/sqrt(x^2))/(1/sqrt(x^2))")
   
      #eq("limits(lim)_(x->oo) (-5)/sqrt(2x^2+11) * 1/(1/sqrt(x^2))")

      #eq("limits(lim)_(x->oo) (-5)/(sqrt(2x^2+11)/sqrt(x^2)))")

      #eq("limits(lim)_(x->oo) (-5)/(sqrt(2x^2+11)/sqrt(x^2)))")

      #eq("limits(lim)_(x->oo) (-5)/(sqrt((2x^2+11)/x^2))")

      #eq("limits(lim)_(x->oo) (-5)/(sqrt((2x^2+11)/x^2))")
      #eq("limits(lim)_(x->oo) (-5)/(sqrt(2 + (11)/x^2))")

      #eq("(-5)/sqrt(2)") 

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
    #solution[
      #html.elem("div")[]
    ]
  ]
  #tmv[
    #problem("Minimize Cost: 2")[ A cylindrical can is to be made to hold 3 cubic meters of liquid. Find the dimensions (radius and
height) of the can that will minimize the cost of its construction if the top and bottom are made
of a material that costs \$3 per square meter and the side is made of a material that costs \$5 per
square meter.
    ]

    #step("Equations for Cyliner and Cost")[
      
      #eq("A = 2 pi r h + 2 pi r^2")
      Top and Bottom
      #eq("C(r) = 2 pi r^2 * 5")
      Sides
      #eq("C(x) = 2pi r h * 3")
      Total
      #eq("C(x) = 10 pi r^2 + 6 pi r h")
    ]
    #step("Volume Function")[
      Cylinder Volume
      #eq("V = pi r^2 h")
      Use Given Volume
      #eq("3 = pi r^2 h")
      #eq("h = 3 / (pi r^2 )")
      Final Cost Function

      #eq("C(r) = 10 pi r^2 + 6 pi r * 3 / (pi r^2)")

      #eq("C(r) = 10 pi r^2 + 18 / ( r )")
    ]
    #step("Minimize")[
      Derivative
      #eq("C'(r) = 20 pi r - 18 / r^2 ")

      Second Derivative

      #eq("C'(r) = 20 pi  + 18 / r^3 ")


      Solve for Zeros

      #eq("20 pi r^3 - 18 = 0")
      #eq("r^3 = 18/(20pi)")
      #eq("r = 0.659220765051")
      
      Second Derivative Test
      #eq("C''(r) > 0")
      It is a local minima
    ]
    #solution[
      #eq("\"Cost\" = \$40.96")
      #eq("\"Radius\" = 0.659220765051")
      #eq("\"Height\" = 3 / (pi r^2 ) \"or\" 2.19740255017")
      #graph_container(
        graph("r = 0.659220765051"),
        graph("C(r) = 10 pi r^2 + 18 / ( r )"),
        graph("C(r)"),
        graph("3 / (pi r^2 )")


      )
    ]
  ]

  

  


]
#week(11)[
      #notes("Indeterminate Forms")[
        #eq("0/0") #eq("oo/oo")
      ]

      #notes("L'Hopital's Rule")[
        If a limit is Indeterminate through direct subsitute then you can use it's derivative to find the limit.
      ]
      #ps("4.8 L'Hopital's Rule with exponentials")[
        #problem("Evaluate Limit")[

        #eq("limits(lim)_(x->oo) 2x e^(1/x) - 2x")
        ]

        #step("Set Up")[
          Factor 
          #eq("x(2e^(1/x) - 2)")
          Trick (Divide by)
          #eq("x = 1 / ( 1 / x )")

          #eq("limits(lim)_(x->oo) ( 2e^(1/x) - 2)/(1/x)")
          Use L'Hopital's Rule (Indeterminate form)

        ]
        #step("Solve Limit with L'Hopital")[

          #eq("limits(lim)_(x->oo) ( 2e^u - 2)/u") #eq("u = 1/x")

          Derivative 

          #eq("limits(lim)_(x->oo) (2e^u  u') / u' ") #eq("u' = -1/x^2")

          
        ]
        #solution[
          As X Approaches U will get Infinitely smaller

          #eq("limits(lim)_(x->oo) 2e^(~0)  = 2 * 1 = 2") #eq("u' = -1/x^2")
        ]

        #problem("L'Hopital with Trig")[
        
          #eq("limits(lim)_(x->0) (e^x - 1) / (sin(11x) = 0 / 0") 
        ]
        #step("Derivative")[

          #eq("limits(lim)_(x->0) e^x / (cos(11x) * 11) ")

          Direct Subsitute

          #eq("limits(lim)_(x->0) 1 / (cos(0) * 11 ")
        ]
        #solution[
        
          #eq("limits(lim)_(x->0) = 1 / 11 ")
        ]

        #problem("Limit with tan trig")[

          #eq("limits(lim)_(x->0) sin(7x) / tan(3x) ")
        ]
        #step("Direct Subsitute")[
          Doesn't work get left with a Indeterminate value #eq("0/0")
        ]
        #step("Derivaitve")[
          
          #eq("limits(lim)_(x->0) 7cos(7x) / 3sec^2(x) ")

        ]
        #solution[
          #eq("7/3")
        ]
        #problem("More exponentials")[

          #eq("limits(lim)_(x->0) (9^x - 11^x) / x") 
          Direct Subsitution Doesn't Work (Give Indeterminate Value)
        ]
        #step("Derivaitve")[

          #eq("limits(lim)_(x->0) (ln(9) * 9^x - ln(11) * 11^x)") 
        ]
        #solution[
          
          #eq("limits(lim)_(x->0)  = ln(9)*1 - ln(11)*1") 
        ]

        #problem("#8")[

          #eq("limits(lim)_(x->oo) (9x^3) / e^(2x) = oo/oo" ) 
        ]
        #step("Derivatives")[
          1st
          #eq("limits(lim)_(x->oo) (27x^2) / (2e^(2x) ) ") 
          2nd
          #eq("limits(lim)_(x->oo) (54x) / (4e^(2x) ) ")
          3rd
          #eq("limits(lim)_(x->oo) (54) / (8e^(2x) ) ")
          4th
          #eq("limits(lim)_(x->oo) 0 / (16e^(2x) ) ")
        ]
        #solution[
          #eq("0/oo = 0")
        ]

      ]
      #problem("L'Hopital with Constant (t)")[

          #eq("limits(lim)_(x->44) (cos(x t) - cos(44t)) / (1936 - x^2) = 0 / 0 ")
      ]
      #step("Derivative")[
          #eq("limits(lim)_(x->44) (- t sin(x t) ) / (-2x) ")
          Plug in

          #eq("(-t sin(44t) ) / (-88) ")

        ]
        #solution[

          #eq("(t  sin(44t)) / (88) ")
        ]

        #problem("357")[

          #eq("limits(lim)_(x->oo) e^x / x^k")
        ]
        #solution[
          #eq("ln( L ) = limits(lim)_(x->oo) ln(e^x / x^k) ")

          #eq("ln( L ) = limits(lim)_(x->oo) ln(e^x) - ln(x^k) ")

          #eq("ln( L ) = limits(lim)_(x->oo) x/e - k/x ")

          #eq("ln( L ) = limits(lim)_(x->oo) (x^2 - e k)/(e x) ")

          L'Hopital
          #eq("ln( L ) = limits(lim)_(x->oo) (2x)/(e) ")

          #eq("L = oo")
          
        ]
        #problem("381")[

          #eq("limits(lim)_(x->1) (sqrt(x) - root(3, x)) / (x-1)")
        ]
        #solution[
          L'Hopital
          #eq("limits(lim)_(x->1) (1/(2sqrt(x)) - 1/(3root(3, x^2))) / (1)")

          Plug In
          #eq("limits(lim)_(x->1) (1/(2*1) - 1/(3*1 ))")

          #eq("L = (1/(2) - 1/(3)) = (3/6-2/6) = 1/6")
        ]

      #ps("4.9 Newton's Method")[
        #notes("Newton's Method")[
          Approximate Find Zeros of Functions

          As the iterations get higher, the estimate will approach the actual zero
          
          General Form
          #eq("n > 0") #eq("x_n = x_(n-1) - f(x_(n-1))/(f'(x_(n-1)))")

          Failures:
          - when #eq("f'(x_n) = 0") 
          - may approach a different root (if has 1+ root)
          - may bounce/alternate between roots

        ]
        #notes("Newton's Method Calculator")[
          #html.elem("a", attrs: (href: "https://www.desmos.com/calculator/hguot8ny02"))[
            Desmos Calculator
          ]
        ]

      ]
      #gpa[
        #problem("9")[

          #eq("limits(lim)_(x->oo) (e^x + x)^(1/x) = L")
          ]
          #step("Exponent Rule")[
         
          #eq(" limits(lim)_(x->oo) ln((e^x + x)^(1/x)) = ln(L)")
          Properties of Logs

          #eq(" limits(lim)_(x->oo) ln((e^x + x))/x = ln(L)")
          ]

          #step("Derivative")[

          #eq(" limits(lim)_(x->oo) ((e^x + 1)/(e^x + x))/1 = ln(L)")

          #eq(" limits(lim)_(x->oo) ((e^x + 1)/(e^x + x)) = ln(L)")
          ]

          #step("L'Hopital Rule")[
          Divide by common term #eq("e^x")
          #eq(" limits(lim)_(x->oo) (1 + 1/e^x)/(1 + x/e^x) = ln(L)")
          
          Inner Term (L'Hopitial Again by taking derivative)
          #eq("limits(lim)_(x->oo) x/e^x ")
          #eq("limits(lim)_(x->oo) 1/e^x = 0 ")
         
          Thus we can plug everything in

          #eq("limits(lim)_(x->oo) (1 + 0)/(1 + 0) = ln(L)")



          ]
          #solution[
            #eq("ln(L) = 1")
            #eq("L = e")

          ]



        #problem("10")[

          #eq("limits(lim)_(x->oo) ((3x-7)/(3x+2))^(3x+1) = oo/oo")
        ]
        #step("Logathrim")[

          #eq("ln(L) = limits(lim)_(x->oo) (3x+1)ln((3x-7)/(3x+2))")

          Convert Into Fraction (for L'Hopital)

          #eq("ln(L) = limits(lim)_(x->oo) ln((3x-7)/(3x+2))/(1/(3x+1))")

          Is still Indeterminate

        ]
        #step("Apply L'Hopital")[
          Logathrim Rules 
          #eq("ln(L) = limits(lim)_(x->oo) (ln(3x-7)-ln(3x+2))/(1/(3x+1))")
          
          Derivative
          #eq("ln(L) = limits(lim)_(x->oo) (3/(3x-7)-3/(3x+2))/(-3/(3x^2))")

          Combine Numerators
          #eq("ln(L) = limits(lim)_(x->oo) (27/((3x-7)(3x+2)))/(-3/(3x^2))")

          Pull out Numerators
          #eq("ln(L) = limits(lim)_(x->oo) -9 * (1/((3x-7)(3x+2)))/(1/(3x^2))")

          Refactor

          #eq("ln(L) = limits(lim)_(x->oo) -9 * (3x^2)/((3x-7)(3x+2))")

          If you divide both sides by 3x^2 you'll get 0 or 1/x^n which when paired with an infinity limit will make it approach 0 

          #eq("ln(L) = limits(lim)_(x->oo) -9 * 1/1")
        ]
        #solution[
          
          #eq("ln(L) = -9 * 1/1") #eq("L = e^(-9)")
                  ]
      ]

      #tmv[
        #problem("3")[

          #eq("limits(lim)_(x->oo) (1+3/x)^(x/5) ")
        ]
        #step("Direct Subsitution")[
          Plug in Infinity
          #eq("L = limits(lim)_(x->oo) (1+0)^(oo)")
          Is Indeterminate
          #eq("L = 1^oo ")
        ]
        #step("L'Hopital")[

          #eq("ln(L) = limits(lim)_(x->oo) (x/5)ln(1+3/x)")
          Make into Form

          #eq("ln(L) = limits(lim)_(x->oo) (ln(1+3/x) )/ ( 5/x ) ")
          Derivative
          #eq("ln(L) = limits(lim)_(x->oo) ( (-3x^(-2) ) /(1+3x^(-1))  )/ ( - 5/x^2) ")

          Combine Numerator
          #eq("ln(L) = limits(lim)_(x->oo) ( (-3 ) /(x^2 + 3x)  )/ ( - 5/x^2) ")
          Divide Both Denominators
          #eq("ln(L) = limits(lim)_(x->oo) ( (-3 ) /(1 + 3/x)  )/ ( - 5) ")
          Plug In X

          #eq("ln(L) = limits(lim)_(x->oo) ( (-3 ) /(1 + 0)  )/ ( - 5)  = 3/5")
          ]
        #solution[
          #eq("ln(L) = 3/5") #eq("L = e^(3/5)") 
        ]
      ]


       
  ]
  #pagebreak()
  #week("12 -- Exam: 3")[
    
    #ps("Written -- Open Response")[
        #problem("1. Graph Function")[]
        #solution[
          #local_image("exam3_question1.png")
          // TODO Image here
        ]
        #problem("2. Optimize Cost")[
          Michelle’s can company needs to construct cans in the shape of a cylinder to hold 36 cubic inches (which is about 20 oz) to hold their new energy drink called Felix-Felicis (aka liquid luck). The cylindrical side of the container will be made of thinner aluminum costing 6 cents per square inch. The top and bottom will be thicker aluminum, costing 10 cents per square inch. Find the dimensions for the package that will minimize production costs. (Find the exact answers for the dimensions, do not use a calculator to round.)
        ]
        #step("Formulas")[
          #eq("V = pi r^2 h")
          #eq("A = 2 pi r h + 2 pi r^2")
          #eq("C(r,h) = 6*2 pi r h + 10 * 2 pi r^2")
        ]
        #step("Expression Relative to H")[
          Plug in Known Volume
          #eq("36 = pi r^2 h")
          Solve
          #eq("36 / (pi r^2) = h")
          Plug Into Cost Function
          #eq("C(r) = (6*2 pi r * 36)/(pi r^2)  + 10 * 2 pi r^2")
          Simplifiy
          #eq("C(r) =  432 /(r)  + 20 pi r^2")
        ]

        #step("Find Minima")[
          First Derivative
          #eq("C'(r) = -432/(r^2) + 40pi r")
          Second Derivative
          #eq("C''(r) = 864/(r^3) + 40pi ")

          Find Zeros of First Derivative

          #eq("-432/(r^2) + 40pi r = 0")

          #eq(" 40pi r = 432/(r^2) ")

          #eq(" 40pi r^3 = 432 ")

          #eq(" r^3 = 432/(40pi) = 54/(5pi) ")

          #eq("r =  root(3,54/(5pi)) ")

          Plug Into Second Derivative
          it's concave up so thus is must be the local minima
          #eq("C''( root(3,54/(5pi)) ) = 376.991118431 ")

        ]
        #solution[

          #eq(" r = root(3,54/(5pi)) ")
          #eq("h = 36 / (pi root(3,(54/(5pi))^2))")
        
          #eq("h = 36 / (pi root(3,(54/(5pi))^2))  * root(3, 54/(5pi))/ root(3, 54/(5pi))")


          #eq("h = (36 * root(3,(54/(5pi)))) / ((54pi)/(5pi) )  ")

          #eq("h = (36 * root(3,(54/(5pi)))) * ((5)/(54) )  ")
          #eq("h = (4 * root(3,(54/(5pi)))) * ((5)/(6) )  ")


          Answers

          #eq(" \"radius\" = root(3,54/(5pi)) ")
          #eq(" \"height\" = (20root(3,(54/(5pi)))) / 6  ")

        ]
        #problem("3.")[A child standing 10 feet away from her Aunt lets go of a balloon at the same height as their Aunt’s eye level. The balloon rises at a constant rate of 3 ft per second. How fast is the angle of elevation from the Aunt to the balloon changing 4 seconds later?]

        #step("Definitions")[
        Going to be forming a right triangle. The balloon is the vertex above the vertex at the right angle and the verex 10ft away is the aunt

        The height of the balloon is raising at a constant rate
        #eq("(d h)/(d t) = 4 ")

        Angle of elevation is relative to the height and distance of the aunt
        #eq("tan(theta)=h/d")

        Find the hide
        it rises at 3ft per second thus after four seconds
        #eq("h = 12")
        ]

        #step("Solving for Theta")[
 
        #eq("theta = arctan(h/d)")

        ]
        #step("Find Rate of Change of Angle")[
          #eq("(d theta)/(d t) = 1 / (1 + (h/d * d/(d t)(h/d))^2 )")

          #eq("(d theta)/(d t) = 1 / (1 + (h/d * ( (d h)/(d t) d - h (d d )/(d t) )/d^2 )^2 )")
        
          #eq("(d theta)/(d t) = 1 / (1 + (12/10 * ( 4 * 10 - 12 * 0 )/100)^2 )")

          #eq("(d theta)/(d t) = 1 / (1 + (16/5 * 2/5)^2 )")

          #eq("(d theta)/(d t) = 1 / (1 + (12/25)^2 )")

          #eq("(d theta)/(d t) = 1 / (625/625 + 144/625 )")


          #eq("(d theta)/(d t) = 1 / (769/625 )")



        ]

        #solution[
          Where theta is the change in angle of elevation
          #eq("(d theta)/(d t) = 625*769")
        ]

    ]
    #tmv[
      #problem("3")[
        #eq("limits(lim)_(x->-oo) (1-x)^(1/ln(x^3)) ")

      ]

      #step("Indeterminate Form")[

        #eq("limits(lim)_(x->-oo) (oo)^(0)) ")
      ]

      #step("Properties of Logathrim")[

        #eq("limits(lim)_(x->-oo) (1-x)^(1/(3ln(x))) ")

      

      ]

      #step("Algebra")[

        #eq("L = limits(lim)_(x->-oo) (1-x)^(1/(3ln(x))) ")
        
        Apply
        #eq("ln(L) = limits(lim)_(x->-oo) (1/(3ln(x)))ln(1-x) ")
        Indeterminate Form

        #eq("limits(lim)_(x->-oo) (0)oo ")
      ]

      #step("L'Hopital")[
        Get into form
        #eq("ln(L) = limits(lim)_(x->-oo) ln(1-x)/(3ln(x)) ")
        Apply Derivaitve
        #eq("ln(L) = limits(lim)_(x->-oo) (-1/(1-x))/(3/x) ")
       Indeterminate Form
        #eq("limits(lim)_(x->-oo) 0/0 ")
        Simplify

        #eq("ln(L) = limits(lim)_(x->-oo) (-1/(1-x))*(x/3) = -x/(3-3x)")


        #eq("ln(L) = limits(lim)_(x->-oo) (-1/(1-x))*(x/3) = -(x/(3-3x)")

        #eq("ln(L) = limits(lim)_(x->-oo) (-1/(1-x))*(x/3) = -(x/x)/(3/x-(3x)/x)")


        #eq("ln(L) =  -1/(-3) = 1/3")

      ]
      #solution[
        Solve for L
        #eq("L = e^(1/3) = root(3, e)")
      ]
    ]


    #week("13")[
      #ps("4.10 Anti-Derivatives")[
        #notes("Definition")[
          #eq("F'(x) = f(x)") #eq("F(x) \"is the anti-derivative\"")
        ]
        #notes("Indefinite Integrals")[
          Anti-Derivative in respect to x
          #eq("integral f(x) d x = F(x) + C")
        ]
        #notes("Power Rule for Integrals")[
        
          #eq("\"For \" x!=-1") #eq("integral x^n d x = x^(n+1)/(n+1) + C")

        ] 

        #notes("Integration Formulas (Anti-Derivatives)")[
          Constants
          #eq("integral k d x = k x + C")
          Eveything is just the opposite of the derivative

        ]


        #problem("Inital Value")[
          #eq("f''(x) = 2x+9sin(x)") #eq("f(0) = 4") #eq("f'(0)=3")
          What is
          #eq("f(2)")
        ]
        #step("Determine First Derivative")[
          #eq("f'(x) = x^2 -9cos(x) + C")
          Figure Out Constant
          #eq("f'(0) = -9 ") 
          #eq("f'(x) = x^2 -9cos(x) + 12")
        ]
        #step("Determine Equation")[
          #eq("f(x) = 1/3x^3 -9sin(x) + 12x + C")
          Figure Out Constant
          #eq("f(0) = 0 ") 
          #eq("f(x) = 1/3x^2 -9sin(x) + 12x + 4")
        ]
        #solution[
          #eq("f(2) = 22.4829898252")
        ]

        #problem("Confusing Physics Problem")[
          A stone is dropped from the edge of a roof, and hits the ground with a velocity of -120 feet per second. How high (in feet) is the roof?
        ]
        #step("Velocity")[
        Inital Velocity is 0
        #eq("v(0) = 0")
        Acceleration is a constant -32
        #eq("a(t) = -32") #eq("v(t) = integral -32 d x =  -32t + C")
        We can figure out the time of the function by using the given value
        #eq("-120 = -32t") #eq("t = 3.75")
        ]
        #step("Position")[
          We know time of the function is 3.75 and the C of the position is going to be the height of the roof
          #eq("p(t) = -16t^2 + C")
          We know the poition of the round so we can solve for C
        
          #eq(" 16t^2 =  225 =   C")



        ]
        #solution[
          The root is 225 ft high
        ]
      ]

      #ps("5.1 Approximate Area")[
        #notes("Summation Formulas")[
          Constant
          #eq("sum_(i=1)^n c = c n")
          Variable
          #eq("sum_(i=1)^n i = (n(n+1))/2")
          Square Variable
          #eq("sum_(i=1)^n i^2 = (n(n+1)(2n+1))/6") 
          Cubed Variable
          #eq("sum_(i=1)^n i^3 = ((n(n+1))/2)^2")
        

   









        ]
        #notes("Under Linear Poly Gone (Triangle with Tip Chopped Off)")[
          #eq("A=1/2(\"side 1\" + \"side 2\") * \" length \"")
        ]
      ]
      #ps("5.2 Definite Intergral")[
        #notes("Riemann Sum Form")[
          General Form
          #eq("integral_a^b f(x) d x = limits(lim)_(n->oo) sum_(k=1) f(x_k) * Delta x")
          Convert to Definite Integral
          #eq("integral_a^b f(x) d x = limits(lim)_(n->oo) sum_(k=1) ((b-a)/n) * f(a + ((b-a)/n)k )")
          Identify Part
          #eq("\"Integral Length\" = (b-a)/n")

        ]
        #notes("Average Value of a Function")[
          #eq("f_(\"ave\") = 1/(b-a) integral_a^b f(x) d x ")
        ]
      ]

      #gpa[
        #problem("#1 Find the Indefinite Integral")[
          #eq("integral[(-3x^4+4x^5)/x^6 - 5root(3,x), 35/sqrt(1-x^2)+5^x + 2] d x")
        ]
      
      #step("Simplify")[

          #eq("integral[(-3+4x)/x^2 - 5x^(1/3), 35/sqrt(1-x^2)+5^x + 2] d x")
      ]
      #step("Find Anti-Derivatives")[
          First Term
          #eq("integral(-3+4x)/x^2 d x = integral-3/x^2 d x + integral(4)/x d x")

          #eq("&  = x^(-3) + 4ln(x)")

          Second Term
          #eq("integral - 5x^(1/3) d x  = -(5*3)/4 x^(4/3)")
          

          Third Term
          #eq("integral 35*(1-x^2)^(-1/2) d x = (35 * -(1-x^2)^(1/2))/x ")

          Fourth Term
          #eq("integral 5^x d x = (5^x)/ln(5)")

          Fifth Term
          #eq("integral 2 d x = 2x")
          
      ]
      #solution[
        #eq("x^(-3) + 4ln(x) -15/4x^(4/3) -( 35sqrt(1-x^2))/x + 5^x/ln(x) + 2x + C")
      ]
      #problem("5.")[
        Find the left handed estimate of
        #eq("f(x) = 3^x - cos(pi x)") #eq("[-3,2]") 
      ]
      #notes("Riemann Summ Formula")[
        Left
        #eq("L_n = limits(sum)^n_(i=1) f(x_(i-1))Delta x ")
        Right
        #eq("L_n = limits(sum)^n_(i=1) f(x_(i))Delta x")
      ]
      #step("Find Change in X")[
        #eq("(2--3)/10 = 1/2")
        

      ]
      #step("Riemann Sum Formula")[

        #eq("L_10 = limits(sum)^10_(i=1) (3^(x_i-1) + cos(pi(x_i - 1)) )Delta x ")
      ]
      #solution[
        #eq("x_i = -3 + 1/2 z ") #eq("z in [1, 10] ")
        #eq("limits(sum)^10_(i=1) f(x_i)Delta x = 0.5 ( 1.03 + 0.06 - 0.89 + 0.19 & + 1.33 + 0.58 + 0 + 1.73 + 4 + 5.20  )")
        #eq("= 6.62")

        #local_image("gpa_week1.png", width: "20vw")
      ]
    ]
    #tmv[
      #problem("1")[
        #eq("integral [(5x^3+4x^5)/x^6 - 6root(4,x) - 35/(1+x^2) - 7^x + 12tan(x)sec(x)]d x")
      ]
      #step("Break Apart and Simplify")[
        Each term can be seperated and then added back together (rules of integrals)

        #eq("integral [(5+4x^2)/x^3] - integral[6root(4,x)] d x - integral[ 35/(1+x^2)] d x + integral  [- 7^x ] d x + integral [ 12tan(x)sec(x)]d x")
      ]
      #step("Solve for each integral seperately")[
        First (Power Rule and Natural Log)
        #eq("integral [(5x+4x^2)/x^3] d x  =  integral [(5)/x^2 + 4x^2/x^3] d x ")

        #eq("integral [(5)/x^2 + 4/x] d x = -5/(3x^3) + 4ln(x) + C ")

        Second (Power Rule)

        #eq(" - integral[6root(4,x)] d x  = - integral[6x^(1/4)] d x = - (6*4)/5 * x^(5/4) + C ")

        Third (Natural Log Rule and Chain Rule)

        #eq("- integral[ 35/(1+x^2)] d x ")
        #eq("(d/(d x)) ln(u) = u'/u")

        #eq("- integral[ 35/(u)] d u = (35ln(u))/u' + C = - (35ln(1+x^2))/(2x) + C ")

        Fourth 

        
        #eq("- integral[ 7^x] d x = 7^x/ln(7) + C")
      
        Fifth 
        #eq("integral [12 tan(x)sec(x)]d x = 12sec(x) + C")
      ]
      #step("Combine All")[

        #eq("-5/(3x^3) + 4ln(x) -5/(3x^3) + 4ln(x) +  (24)/5 root(4,x^(5)) - (35ln(1+x^2))/(2x) - 7^x/ln(7) + 12sec(x) + C")

      ]

    ]




    ]



    #week("15")[
      #notes("Important Integrations Cheatsheet")[
        #eq("d/(d x) sin^(-1)(x/a) = 1/sqrt(a^2-x^2)") 
        #eq("d/(d x) cos^(-1)(x/a) = - 1/sqrt(a^2-x^2)")
        #eq("d/(d x) tan^(-1)(x/a) = a/(a^2+x^2)") 
        #eq("d/(d x) cot^(-1)(x/a) = -a/(a^2+x^2)")
        #eq("d/(d x) 1/a csc^(-1)(x/a) = -1/((|x|sqrt(x^2-a^2))") 
        #eq("d/(d x) 1/a sec^(-1)(x/a) = 1/(|x|sqrt(x^2-a^2))")
        #eq("d/(d theta) ln(a cos(theta) ) = - tan( theta ) ")
        #eq("d/(d theta) ln(a sin(theta) ) = cot( theta ) ")

      ]
      #ps("5.5 ")[
        #problem("1")[
          #eq("integral (6x + 7)/(x^2 + 1) d x")
        ]
        #step("Solve")[
          #eq("u = x^2 + 1 ") #eq(" d u = 2x")
          #eq("integral 3/u d u + integral 7/(x^2 + 1)")

          #eq("3ln(u) + 7 arctan(x) + C")

        ]
        #solution[#eq("3ln(x^2 + 1) + 7arctan(x) + C")]

        #problem("4")[
          #eq("integral x^3/sqrt(1 - x^8)")
        ]
        #step("Integrate")[
          #eq("u = x^4") #eq("d u = 4x^3")
          #eq("integral (d u) /sqrt(1-u^2) * 4/4")
          #eq("1/4 integral (1) /sqrt(1-u^2) d u ")
          #eq("1/4arcsin(u) + C")

        ]
        #solution[

          #eq("1/4arcsin(x^4) + C")
        ]

        #problem("5")[
          #eq("4 integral 1/sqrt(6-24x^2) d x")
                  ]
        #step("Integrate")[
          #eq("u = sqrt(24) x ")  #eq("d u = sqrt(24)")

          #eq("4 integral 1/sqrt(6-u^2) * sqrt(24)/sqrt(24)")
        
          #eq("4 integral 1/sqrt(6-u^2) * 1/sqrt(24) d u")

          #eq("a = sqrt(6)")

          #eq("4 integral 1/sqrt(a^2-u^2) * 1/sqrt(24) d u")

          #eq("4/sqrt(24) integral 1/sqrt(a^2-u^2) d u = 4/sqrt(24) arcsin(u/a)")

          #eq("sqrt(6)/3 arcsin(2sqrt(6)x)/(sqrt(6))")
          
          #eq("sqrt(6)/3 arcsin(2x)")

        ]
        #problem("6")[
          #eq("9 integral x/(x^4 + 1)")
        ]
        #step("Integrate")[
          #eq("u = x^2") #eq("d u = 2x")
          #eq("9 integral x/(u^2 + 1) * 2/2")
          #eq("9/2 integral 1/(u^2 + 1) d u")

          #eq("9/2 arctan(u) ")
        ]
        #solution[#eq("9/2 arctan(x^2)")]

        #problem("7")[
          #eq("integral x^3/sqrt(x^2+16)")

        ]#step("Integrate")[
          #eq("u = x^2 + 16") #eq("d u = 2x")
          #eq("integral x^3/sqrt(u)")
          #eq("integral (x^2 * x)/sqrt(u) * 2/2")
          #eq("1/2 integral x^2/sqrt(u) d u  ")
          #eq("1/2 integral (u-16)/sqrt(u) d u")
          #eq("1/2 (integral (u)*u^(-1/2) d u - integral 16/sqrt(u))")

          #eq("1/2 (integral u^(1/2) d u - 16 integral u^(-1/2))")
        
          #eq("1/2 (2/3 u^(3/2) - 16 * 2 u^(1/2))")


          #eq("(1/3 u^(3/2) - 16u^(1/2))")

          #eq("(1/3 (x^2+16)^(3/2) - 16(x^2+16)^(1/2))")
        ]
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
