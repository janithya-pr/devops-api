package main

import (
	"log"
	"net/http"

	"github.com/go-chi/chi/v5"

	"github.com/janithya-pr/devops-api/internal/config"
	"github.com/janithya-pr/devops-api/internal/handler"
)

func main() {
	cfg := config.Load()

	r := chi.NewRouter()

	profileHandler := handler.NewProfileHandler(cfg)

	// r.Get("/api/v1/profile", profileHandler.GetProfile)
	r.Route("/api/v1", func(r chi.Router) {
		r.Get("/profile", profileHandler.GetProfile)
	})

	log.Println("server running on :8080")
	if err := http.ListenAndServe(":8080", r); err != nil {
		log.Fatal(err)
	}
}