package utils

import "main/cmd/data"

func GetImage(os string, arch string, is_manual bool) string {
	if is_manual && arch == "arm64" {
		return "net9/ubuntu-24.04-arm64"
	} else if is_manual && arch == "amd64" {
		return "bento/ubuntu-24.04"
	}

	for _, image := range data.ImageArch {
		if image.Name == os && image.Arch == arch {
			return image.Image
		}
	}
	return ""
}