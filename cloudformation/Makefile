.PHONY: help
help: ## この文章を表示します。
	# http://postd.cc/auto-documented-makefile/
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: deploy
deploy: .cache/monitor ## デプロイします。
.DELETE_ON_ERROR: .cache/monitor
.cache/monitor: monitor.yaml
	./scripts/deploy-stack.sh monitor
