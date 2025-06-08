package cmd

import (
	"os"

	"github.com/spf13/cobra"

	"main/cmd/utils"
)

var rootCmd = &cobra.Command{
	Use: "kvc",
	Short: "kvc stands for Kubeadm Vagrant Configuration generator in go",
	Long: "kvc is a tool to generate configuration files for Vagrant and Kubeadm.",
}

func Execute() {
	cobra.CheckErr(rootCmd.Execute())
}

func init() {
	cobra.OnInitialize(initConfig)
}

func initConfig() {
	filesToCheck := []string{
		"configuration.yaml",
		".env.master",
		".env.worker",
	}

	utils.Yellowf("Checking important files...\n")
	_, err := os.Stat("Vagrantfile")
	if os.IsNotExist(err) {
		cobra.CheckErr(err)
		panic("Missing Vagrantfile, unable to continue")
	} else if err != nil {
		cobra.CheckErr(err)
		panic("Error checking Vagrantfile, unable to continue")
	}

	for _, file := range filesToCheck {
		err := utils.CheckAndCreateFile(file)
		cobra.CheckErr(err)
	}
}
