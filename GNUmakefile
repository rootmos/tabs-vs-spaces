tests:
	tests/runner.sh tests/heuristics.vim
	tests/runner.sh -t3 tests/plugin.vim
	tests/runner.sh -t-3 tests/plugin.vim

DOCKER ?= docker

test-in-docker: .docker-image
	$(DOCKER) run --rm $(file <$<)

.PHONY: .docker-image
.docker-image: .FORCE
	$(DOCKER) build --iidfile=$@ --file=tests/Dockerfile .

.FORCE:

.PHONY: tests test-in-docker .FORCE
