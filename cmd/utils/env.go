package utils

import (
    "bufio"
    "os"
    "strings"
    
    "main/cmd/models"
)

// LoadEnv reads environment variables from a file and returns them as a slice of EnvVar.
// Format of the file should be KEY=VALUE, one per line.
// Comments (lines starting with #) and empty lines are ignored.
func LoadEnv(filename string) ([]models.EnvVar, error) {
    file, err := os.Open(filename)
    if err != nil {
        if os.IsNotExist(err) {
            return []models.EnvVar{}, nil
        }
        return nil, err
    }
    defer file.Close()

    var envVars []models.EnvVar
    scanner := bufio.NewScanner(file)

    for scanner.Scan() {
        line := strings.TrimSpace(scanner.Text())
        
        // Skip empty lines and comments
        if line == "" || strings.HasPrefix(line, "#") {
            continue
        }
        
        // Split the line by the first equals sign
        parts := strings.SplitN(line, "=", 2)
        if len(parts) != 2 {
            continue // Skip invalid lines
        }
        
        key := strings.TrimSpace(parts[0])
        value := strings.TrimSpace(parts[1])
        
        // Remove quotes if present
        value = strings.Trim(value, `"'`)
        
        envVars = append(envVars, models.EnvVar{
            Name:  key,
            Value: value,
        })
    }

    if err := scanner.Err(); err != nil {
        return nil, err
    }

    return envVars, nil
}