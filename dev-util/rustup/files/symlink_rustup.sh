#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

SYMLINK_RUSTUP_VERSION="0.0.1"

: "${CARGO_HOME:=${HOME}/.cargo}"
: "${RUSTUP_HOME:=${HOME}/.rustup}"

__err_exists="already exists, remove and re-run the script"

# dies with optional message
die() {
	[[ ${QUIET-no} ]] && echo -e "${NOCOLOR=\e[1;31m*\e[0m }ERROR: ${*}" >&2
	exit 1
} # die()


# outputs gentoo-style green * prefixed message, a good one ofc
good() {
	[[ ${QUIET-no} ]] && echo -e "${NOCOLOR=\e[1;32m*\e[0m }${*}"
	return 0
} # good()


# do I need to explain this?
usage() {
	echo "Usage: ${0} [<options>]"
} # usage()

# and this
help() {
	usage
	echo
	echo -n "Symlink system installation of rustup to"
	echo " ${CARGO_HOME}"
	echo
	echo "Options:"
	echo "	-C, --nocolor	Disable colored output"
	echo "	-d, --debug	Debug mode (sets -x shell option)"
	echo "	-V, --version	Print version number"
	echo "	-q, --quiet	Quiet mode"
} # help()


symlink_rustup() {
	local binpath gentoo_rust tool tools=(
		cargo{,-clippy,-fmt,-miri}
		clippy-driver
		rls
		rust{c,doc,fmt,-gdb,-lldb,up}
	)

	binpath="${EPREFIX:-}/usr/bin/rustup-init"
	gentoo_rust="$(eselect --brief rust show 2>/dev/null)"

	mkdir -p "${CARGO_HOME}/bin" || die

	for tool in "${tools[@]}"; do
		local symlink_path="${CARGO_HOME}/bin/${tool}"
		if [[ -e "${symlink_path}" ]]; then
			die "${symlink_path} ${__err_exists}"
		else
			ln -sv "${binpath}" "${symlink_path}" || die
		fi
	done

	good "Setting gentoo ${gentoo_rust// /} as default toolchain"
	"${CARGO_HOME}/bin/rustup" -v toolchain link gentoo "${EPREFIX:-}/usr" || die
	"${CARGO_HOME}/bin/rustup" -v default gentoo || die
	"${CARGO_HOME}/bin/rustup" -V || die
	"${CARGO_HOME}/bin/rustup" show || die

	good "Prepend ${CARGO_HOME}/bin to your PATH to use rustup"
	good "rustup selfupdate is disabled, it will be updated by portage"
} # symlink_rustup()


main(){
	local me
	me="$(basename "${BASH_SOURCE[${#BASH_SOURCE[@]} - 1]}")"
	while [[ ${#} -gt 0 ]]; do
		case ${1} in
			-h|--help)
				help
				exit 0
				;;
			-V|--version)
				echo "${me} ${SYMLINK_RUSTUP_VERSION:-unknown}"
				exit 0
				;;
			-d|--debug)
				set -x
				;;
			-C|--nocolor)
				NOCOLOR=
				;;
			-q|--quiet)
				QUIET=
				;;
			-*)
				usage >&2
				exit 1
				;;
		esac
		shift
	done
	symlink_rustup
} # main()


main "${@}"
