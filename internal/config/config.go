package config

import (
	"github.com/spf13/viper"
)

type Config struct {
	ServerPort         string `mapstructure:"PORT"`
	MongoURI           string `mapstructure:"MONGO_URI"`
	DBName             string `mapstructure:"DB_NAME"`
	JWTSecretKey       string `mapstructure:"JWT_SECRET_KEY"`
	JWTExpirationHours int    `mapstructure:"JWT_EXPIRATION_HOURS"`
	EnableCache        bool   `mapstructure:"ENABLE_CACHE"`
	RedisAddr          string `mapstructure:"REDIS_ADDR"`
	RedisPassword      string `mapstructure:"REDIS_PASSWORD"`
	LogLevel           string `mapstructure:"LOG_LEVEL"`
	LogFormat          string `mapstructure:"LOG_FORMAT"`
}

func LoadConfig(path string) (config Config, err error) {
	// Set defaults first
	viper.SetDefault("PORT", "8080")
	viper.SetDefault("ENABLE_CACHE", false)
	viper.SetDefault("JWT_EXPIRATION_HOURS", 72)

	// Try reading .env file — optional, don't fail if missing
	viper.AddConfigPath(path)
	viper.SetConfigName(".env")
	viper.SetConfigType("env")

	if err = viper.ReadInConfig(); err != nil {
		if _, ok := err.(viper.ConfigFileNotFoundError); ok {
			err = nil // file not found is fine
		} else {
			return
		}
	}

	// CRITICAL: explicitly bind env vars — fixes AutomaticEnv + Unmarshal bug
	viper.BindEnv("PORT")
	viper.BindEnv("MONGO_URI")
	viper.BindEnv("DB_NAME")
	viper.BindEnv("JWT_SECRET_KEY")
	viper.BindEnv("JWT_EXPIRATION_HOURS")
	viper.BindEnv("ENABLE_CACHE")
	viper.BindEnv("REDIS_ADDR")
	viper.BindEnv("REDIS_PASSWORD")
	viper.BindEnv("LOG_LEVEL")
	viper.BindEnv("LOG_FORMAT")

	viper.AutomaticEnv()

	err = viper.Unmarshal(&config)
	return
}