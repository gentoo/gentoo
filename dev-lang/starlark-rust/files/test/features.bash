#!/usr/bin/env bash

# shellcheck disable=SC2034
STARLARK_RUST_EXPECTED_functions=(
	any
	dir
	fail
	getattr
	hasattr
	hash
	len
	max
	min
	print
	range
	repr
	reversed
	sorted
	type
	zip
)

# shellcheck disable=SC2034
STARLARK_RUST_EXPECTED_types=(
	bool
	int
	list
	str
	tuple
	dict
)

# shellcheck disable=SC2034
STARLARK_RUST_EXPECTED_dict_methods=(
	clear
	get
	items
	keys
	pop
	popitem
	setdefault
	update
	values
)

# shellcheck disable=SC2034
STARLARK_RUST_EXPECTED_list_methods=(
	append
	clear
	extend
	index
	insert
	pop
	remove
)

# shellcheck disable=SC2034
STARLARK_RUST_EXPECTED_str_methods=(
	capitalize
	count
	elems
	endswith
	find
	format
	index
	isalnum
	isalpha
	isdigit
	islower
	isspace
	istitle
	isupper
	join
	lower
	lstrip
	partition
	replace
	rfind
	rindex
	rpartition
	rsplit
	rstrip
	split
	splitlines
	startswith
	strip
	title
	upper
)

_test-features_execute-test() {
	local error_msg test_title=$1 test_stdin=$2 exp_stdout=$3 exp_stderr=$4 exp_exitcode=$5
	ebegin "$test_title"
	error_msg=$(
		stderr_file=$(mktemp) || exit
		cleanup() { rm -f "$stderr_file"; }
		trap cleanup EXIT

		test_stdout=$("$starlark_binary" -i --json <<< "$test_stdin" 2>"$stderr_file")
		test_exitcode=$?

		if (( test_exitcode != exp_exitcode )); then
			echo "unexpected exit code \"$test_exitcode\", expected exit code \"$exp_exitcode\" for test_stdin: $test_stdin"
			exit 1
		elif [[ "$test_stdout" != "$exp_stdout" ]]; then
			echo "unexpected stdout \"$test_stdout\", expected stdout \"$exp_stdout\" for test_stdin: $test_stdin"
			exit 1
		elif [[ $(< "$stderr_file") != "$exp_stderr" ]]; then
			echo "unexpected stderr \"$(< "$stderr_file")\", expected stderr \"$exp_stderr\" for test_stdin: $test_stdin"
			exit 1
		fi
		exit 0
	)
	eend $? "$error_msg"

	# shellcheck disable=SC2015
	[[ $error_msg ]] && failures+=("$error_msg") || (( successes += 1 ))
}

test-features_main() {
	local starlark_binary=$1
	local failures=() successes=0
	local banner_width=45

	local attr attr_type test_case
	for attr_type in function type; do
		printf -- '\n\n' >&2
		printf -- '%s\n' "Checking for existence of expected ${attr_type}s" >&2
		eval "printf -- '=%.0s' {1..${banner_width}}" >&2
		echo >&2
		while read -r attr; do
			test_case=(
				"$attr"
				"$attr and print('$attr exists')"
				"$attr exists"
				""
				0
			)
			_test-features_execute-test "${test_case[@]}"
		done < <(eval "printf -- '%s\n' \"\${STARLARK_RUST_EXPECTED_${attr_type}s[@]}\"")
	done

	local attr attr_type test_case type_literal
	for attr_type in dict list str; do
		printf -- '\n\n' >&2
		printf -- '%s\n' "Checking ${attr_type} built-in methods" >&2
		eval "printf -- '=%.0s' {1..${banner_width}}" >&2
		echo >&2

		case $attr_type in
			str)
				type_literal='""'
				;;
			*)
				type_literal="$attr_type()"
				;;
		esac

		while read -r attr; do
			test_case=(
				"$attr_type.$attr"
				"hasattr($type_literal, \"$attr\") and print('$attr method exists')"
				"$attr method exists"
				""
				0
			)
			_test-features_execute-test "${test_case[@]}"
		done < <(eval "printf -- '%s\n' \"\${STARLARK_RUST_EXPECTED_${attr_type}_methods[@]}\"")
	done

	printf -- '\n\n' >&2
	printf -- '%s\n' "Checking for miscellaneous starlark features" >&2
	eval "printf -- '=%.0s' {1..${banner_width}}" >&2
	printf -- '\n\n' >&2

	test_case=(
		'list comprehension'
		'[print("output from list comprehension") for i in range(0, 1) if (i == 0 and True) or not False]'
		'output from list comprehension'
		""
		0
	)
	_test-features_execute-test "${test_case[@]}"
	printf -- '\n\n' >&2

	if (( ${#failures[@]} > 0 )); then
		echo "${#failures[@]} test (s) failed" >&2
		return 1
	elif (( successes == 0 )); then
		echo "no tests ran" >&2
		return 1
	fi
}
