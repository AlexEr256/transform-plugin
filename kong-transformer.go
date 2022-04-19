package main

import (
	"github.com/Kong/go-pdk"
)

type Config struct {
	Host string `json:"host"`
}

func New() interface{} {
	return &Config{}
}

func (config Config) Access(kong *pdk.PDK) {
	key, err := kong.Request.GetQueryArg("key")
	apiKey := config.Host
	if err != nil {
		kong.Log.Err(err.Error())
	}
	x := make(map[string][]string)
	x["Content-Type"] = append(x["Content-Type"], "application/json")
	if apiKey != key {
		kong.Response.Exit(403, "Youu have no correct key", x)
	}
}
