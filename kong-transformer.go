package main

import (
	"strconv"
	"strings"

	"github.com/Kong/go-pdk"
)

var Version string = "0.2"
var Priority int = 1

type Config struct {
	Host string `json: "host"`
}

func New() interface{} {
	return &Config{}
}

func (conf Config) Access(kong *pdk.PDK) {

	newHost := conf.Host

	if len(newHost) == 0 {
		oldHost, hostErr := kong.Request.GetHost()
		oldPort, portErr := kong.Request.GetPort()

		if hostErr == nil && portErr == nil {
			err := kong.Service.SetTarget(oldHost, oldPort)

			if err != nil {
				kong.Log.Err("Unable to set target")
				kong.Response.ExitStatus(400)
			}
		} else {
			kong.Log.Err("Unable to read host and port parameters")
			kong.Response.ExitStatus(400)
		}
	}
	splittedHost := strings.Split(newHost, ":")

	port, err := strconv.Atoi(splittedHost[1])
	host := splittedHost[0]

	if err == nil {
		err = kong.Service.SetTarget(host, port)

		if err != nil {
			kong.Log.Err("Unable to set target")
			kong.Response.ExitStatus(400)
		}
	} else {
		kong.Log.Err("Check input host parameter")
		kong.Response.ExitStatus(400)
	}

}
