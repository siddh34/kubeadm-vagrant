package utils

import "os"

func CheckAndCreateFile(fileName string) error {
	_, err := os.Stat(fileName)
	if os.IsNotExist(err) {
		Orangef("File %s does not exist, creating it...\n", fileName)
		file, err := os.Create(fileName)
		if err != nil {
			return err
		}
		Greenf("File %s created successfully.\n", fileName)
		defer file.Close()
	} else if err != nil {
		return err
	}
	return nil
}