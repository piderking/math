dev:
    typst watch --features html main.typ main.html

serve:
    python3 -m http.server 9090 

build:
    typst compile --features html main.typ main.html
