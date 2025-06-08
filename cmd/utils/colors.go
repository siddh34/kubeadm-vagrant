package utils

import (
	color "github.com/fatih/color"
)

var (
	Redf     = color.New(color.FgRed).PrintfFunc()
	Greenf   = color.New(color.FgGreen).PrintfFunc()
	Yellowf  = color.New(color.FgYellow).PrintfFunc()
	Bluef    = color.New(color.FgBlue).PrintfFunc()
	Magentaf = color.New(color.FgMagenta).PrintfFunc()
	Cyanf    = color.New(color.FgCyan).PrintfFunc()
	Whitef   = color.New(color.FgWhite).PrintfFunc()
	Boldf    = color.New(color.Bold).PrintfFunc()
	Orangef  = color.New(color.FgHiRed).PrintfFunc()
)