// Demosrv starts a basic go http server that serves a simple html page

package main

import (
	"flag"
	"fmt"
	"html/template"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"path"
)

var port = flag.Uint("p", 8000, "server listening port")
var msg = flag.String("m", "Blue-Green Deployment Demo", "text to display on the web page")
var help = flag.Bool("h", false, "display help")

// indexPage contains the served page
var indexHTML *template.Template

func main() {
	flag.Parse()

	if *help || (flag.Arg(0) == "help") {
		flag.Usage()
		os.Exit(0)
	}

	var err error
	indexHTML, err = cacheHTML()
	if err != nil {
		log.Fatalf("error loading html page template: %v", err)
	}

	http.HandleFunc("/", handler)
	laddr := fmt.Sprintf("0.0.0.0:%d", *port)
	log.Fatal(http.ListenAndServe(laddr, nil))
}

// cacheHTML loads the html template content in indexHTML
func cacheHTML() (*template.Template, error) {

	htmlPage, err := ioutil.ReadFile(path.Join("www", "index.html.gohtml"))
	if err != nil {
		return nil, err
	}

	return template.Must(template.New(string("index")).Parse(string(htmlPage))), nil
}

func handler(w http.ResponseWriter, r *http.Request) {
	indexHTML.Execute(w, *msg)
}
