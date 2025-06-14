package utils

func GetScripts(os_type string, ip_address string, manual_mode bool, is_master bool) string {
	script := "scripts/"

	if manual_mode && is_master {
		script += "manuals/master.sh"
	} else if manual_mode && !is_master {
		script += "manuals/nodes.sh"
	} else if is_master {
		script += os_type + "/master.sh"
	} else if !is_master {
		script += os_type + "/nodes.sh"
	}
	return script
}
