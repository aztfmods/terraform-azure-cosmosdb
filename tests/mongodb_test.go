package tests

import (
	"fmt"
	"os"
	"path/filepath"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

var filesToCleanup = []string{
	"*.terraform*",
	"*tfstate*",
}

const (
	successColor = "\033[1;32m"
	failureColor = "\033[1;31m"
	resetColor   = "\033[0m"
)

func TestApplyNoError(t *testing.T) {
	t.Parallel()

	tests := map[string]string{
		"simple":  "../examples/simple",
		"mongodb": "../examples/mongodb",
		"sqldb":   "../examples/sqldb",
	}

	for name, path := range tests {
		t.Run(name, func(t *testing.T) {
			terraformOptions := &terraform.Options{
				TerraformDir: path,
				NoColor:      true,
				Parallelism:  2,
			}

			terraform.WithDefaultRetryableErrors(t, &terraform.Options{})

			defer cleanupFiles(path)
			defer func() {
				terraform.Destroy(t, terraformOptions)
				cleanupFiles(path)
			}()

			terraform.InitAndApply(t, terraformOptions)
		})
	}
}

func cleanupFiles(dir string) {
	for _, pattern := range filesToCleanup {
		matches, err := filepath.Glob(filepath.Join(dir, pattern))
		if err != nil {
			fmt.Println("Error:", err)
			continue
		}
		for _, filePath := range matches {
			if err := os.RemoveAll(filePath); err != nil {
				fmt.Printf("%sFailed to remove %s: %v%s\n", failureColor, filePath, err, resetColor)
			} else {
				fmt.Printf("%sSuccessfully removed %s%s\n", successColor, filePath, resetColor)
			}
		}
	}
}
