.PHONY: simple mongodb

simple:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/simple

mongodb:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/mongodb

sqldb:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/sqldb