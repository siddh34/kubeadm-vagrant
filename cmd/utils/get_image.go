package utils

import "main/cmd/data"

func GetImage(os string, arch string) string {
	for _, image := range data.ImageArch {
		if image.Name == os && image.Arch == arch {
			return image.Image
		}
	}
	return ""
}