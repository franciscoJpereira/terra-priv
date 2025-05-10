package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte(fmt.Sprintf("{\n\tpath: %s\n}", r.URL.Path)))
	})

	log.Fatal(http.ListenAndServe(":8080", nil))
}
