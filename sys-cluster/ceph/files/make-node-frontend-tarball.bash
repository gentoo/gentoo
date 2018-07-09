#!/bin/bash

frontend_path="src/pybind/mgr/dashboard/frontend"
node_dir="node_modules"
output_name_format="ceph-%s-frontend-node-modules.tar.xz"
cache_dir_format="ceph-%s-npm-cache"

# regexes for modules to remove
remove_modules=(
	"^karma.*"
	"^jasmine.*"
	".+/jasmine.*"
	"^tslint.*"
	"^codelyzer"
	"^protractor"
	"^ts-node"
)

# location to find dependencies to prune
node_dep_location="devDependencies"

# node package files
node_package_file="package.json"
node_package_lock="package-lock.json"

# system commands needed
dependencies=(
	wget
	git
	gzip
	jq
	tar
	xz
)

check_deps() {
	local dep

	for dep in "${dependencies[@]}"; do
		if ! command -v "${dep}" >/dev/null; then
			printf '%s: ERROR could not find required command "%s"\n' "${appname}" "${dep}" >&2
			exit 1
		fi
	done

	# make sure that jq was compiled with support for regexes
	if ! jq -c 'map( select(. | test("TEST"; "i")))' <<< '{"TEST": "TEST"}' >/dev/null; then
		printf '%s: ERROR: jq does not support regular expressions, make sure the "oniguruma" USE flag is enabled\n' \
			"${appname}"
		exit 1
	fi
	:
}

get_npm_packages() {
	local tempfile jq_regex full_cache_dir

	full_cache_dir="${PWD}/${cache_dir}"

	pushd "${source_path}/${frontend_path}" > /dev/null
	if [[ ! -r "${node_package_file}" ]]; then
		printf '%s: ERROR: could not find "%s" in "%s"\n' "${appname}" \
			"${node_package_file}" "${frontend_path}"
		exit 1
	fi

	tempfile="$(TMPDIR="." mktemp packages-XXXXX.json)"

	jq_regex="$(printf "%s|" "${remove_modules[@]}")"

	# filter out test only deps that pull in precompiled binaries
	# shellcheck disable=SC2031
	jq --monochrome-output --raw-output --exit-status \
		'."'"${node_dep_location}"'"|=with_entries(select(.key|test("('"${jq_regex%|}"')")|not))' \
		"${node_package_file}" > "${tempfile}"

	# make sure output is still valid JSON
	jq . --exit-status "${tempfile}" > /dev/null

	mv "${tempfile}" "${node_package_file}"

	rm -rf "${full_cache_dir:?}" "${node_dir:?}" "${node_package_lock:?}"

	npm install --ignore-scripts --cache="${full_cache_dir}"

	popd >/dev/null
}

main() {
	local appname source_path version cache_dir

	set -e
	set -o pipefail
	shopt -s nullglob

	appname=$(basename "${0}")
	source_path="${1}"
	version="${2}"

	if [[ -z ${source_path} || -z ${version} ]]; then
		printf 'Syntax: %s <source directory> <version>\n' "${appname}" >&2
		return 1

	elif [[ ! -d ${source_path} ]]; then
		printf '%s: ERROR: Not a directory: %s\n' "${appname}" "${source_path}"
		return 1
	fi

	check_deps

	# shellcheck disable=SC2059
	cache_dir="$(printf -- "${cache_dir_format}\\n" "${version}")"

	get_npm_packages
	pack_tarball
}

pack_tarball() {
	local output

	# shellcheck disable=SC2059
	output="$(printf -- "${output_name_format}\\n" "${version}")"

	tar caf "${output}" \
		--numeric-owner \
		--anchored \
		--owner="root:0" \
		--group="root:0" \
		--exclude-vcs \
		--transform="s:^${source_path}/:ceph-${version}/:" \
		"${cache_dir}" \
		"${source_path}/${frontend_path}/${node_package_file}" \
		"${source_path}/${frontend_path}/${node_package_lock}"

	printf '%s: Output written to "%s"\n' "${appname}" "${output}"
}

main "${@}"

# vim:ft=sh:noet:ts=4:sts=4:sw=4:
