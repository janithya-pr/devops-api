package handler

import (
	"encoding/json"
	"net/http"

	"github.com/janithya-pr/devops-api/internal/config"
)

type ProfileHandler struct {
	cfg config.Config
}

func NewProfileHandler(cfg config.Config) *ProfileHandler {
	return &ProfileHandler{
		cfg: cfg,
	}
}

type ProfileResponse struct {
	Name  string `json:"name"`
	Title string `json:"title"`
	Email string `json:"email"`
	Phone string `json:"phone"`
}

func (h *ProfileHandler) GetProfile(w http.ResponseWriter, r *http.Request) {
	resp := ProfileResponse{
		Name:  h.cfg.ProfileName,
		Title: h.cfg.ProfileTitle,
		Email: h.cfg.ProfileEmail,
		Phone: h.cfg.ProfilePhone,
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)

	_ = json.NewEncoder(w).Encode(resp)
}