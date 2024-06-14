SH_FILES := $(wildcard *.sh)
TEST_FILES := $(filter-out tests-common.sh version-funcs.sh, $(SH_FILES))
TEST_OK_FILES := $(patsubst %.sh, .%.sh.ok,$ $(TEST_FILES))

# !!! _All_ recipe lines for each target will be provided to a single
# !!! invocation of the shell.
.ONESHELL:

# We cache a successful test result if the testfile itself did not
# change (%.sh) and the contents of the eclass/ directory did not
# change (.eclasssum).
.%.sh.ok: %.sh .eclasssum
	./$< && touch $@

.PHONY: test
test: $(TEST_OK_FILES)

.PHONY: force
.eclasssum: SHELL = /bin/bash
.eclasssum: force
	set -euo pipefail
	find .. -maxdepth 1 -type f -name "*.eclass" \
		-exec stat --format="%n %y" \{} \+ |\
		sort |\
		cksum -	> $@.cur
	trap "rm -f $@.cur" EXIT
	if ! cmp --silent $@.cur $@; then
		mv $@.cur $@
	fi
