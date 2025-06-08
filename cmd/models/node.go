package models

type Node struct {
    Name     string     `yaml:"name"`
    Hostname string     `yaml:"hostname"`
    IP       string     `yaml:"ip"`
    CPUs     int        `yaml:"cpus"`
    Memory   int        `yaml:"memory"`
    Image    string     `yaml:"image"`
    Script   string     `yaml:"script"`
    DiskSize string     `yaml:"disk_size"`
    Env      []EnvVar   `yaml:"env,omitempty"`
}

type EnvVar struct {
    Name  string `yaml:"name"`
    Value string `yaml:"value"`
}

type Config struct {
    Nodes []Node `yaml:"nodes"`
}