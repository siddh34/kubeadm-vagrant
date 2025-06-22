package data

import (
	"main/cmd/models"
)

var ImageArch = []models.ImageData{
	{Arch: "amd64", Name: "ubuntu", Image: "bento/ubuntu-24.04"},
	{Arch: "arm64", Name: "ubuntu", Image: "net9/ubuntu-24.04-arm64"},
	{Arch: "amd64", Name: "fedora", Image: "fedora/41-cloud-base"},
}
