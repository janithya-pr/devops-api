package config

import (
	"log"
	"os"

	"github.com/joho/godotenv"
)

type Config struct {
	ProfileName  string
	ProfileTitle string
	ProfileEmail string
	ProfilePhone string
}

func Load() Config {
	if err := godotenv.Load(); err != nil {
		log.Println("warning: .env not found")
	}

	return Config{
		ProfileName: getEnv("PROFILE_NAME"),
		ProfileTitle: getEnv("PROFILE_TITLE"),
		ProfileEmail: getEnv("PROFILE_EMAIL"),
		ProfilePhone: getEnv("PROFILE_PHONE"),
	}
}

func getEnv(key string) string {
	return os.Getenv(key)
}