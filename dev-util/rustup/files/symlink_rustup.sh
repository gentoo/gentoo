#!@GENTOO_PORTAGE_EPREFIX@/bin/bash

set -euo pipefail
IFS=$'\n\t'

SYMLINK_RUSTUP_VERSION="0.0.4"
binpath="@GENTOO_PORTAGE_EPREFIX@/usr/bin/rustup-init"

: "${CARGO_HOME:=${HOME}/.cargo}"
: "${RUSTUP_HOME:=${HOME}/.rustup}"

__err_exists="already exists, try using -u|--unsymlink option first"

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
	echo "	-s, --symlink	Setup rustup symlinks in ${CARGO_HOME}/bin"
	echo "	-C, --nocolor	Disable colored output"
	echo "	-d, --debug	Debug mode (sets -x shell option)"
	echo "	-V, --version	Print version number"
	echo "	-u, --unsymlink	Remove rustup symlinks from ${CARGO_HOME}/bin"
	echo "	-q, --quiet	Quiet mode"
} # help()


symlink_rustup() {
	local gentoo_rust tool
	# rustup calls those proxies
	# src/lib.rs TOOLS
	local tools=(
		rustc
		rustdoc
		cargo
		rust-lldb
		rust-gdb
		rust-gdbgui
		rls
		cargo-clippy
		clippy-driver
		cargo-miri
	)

	# src/lib.rs DUP_TOOLS
	# those can be installed via cargo and not with rust itself
	local dup_tools=(
		rust-analyzer
		rustfmt
		cargo-fmt
	)

	# we need rustup symlink too, so add it to final list
	tools+=( "${dup_tools[@]}" rustup )

	gentoo_rust="$(eselect --brief rust show 2>/dev/null)"

	mkdir -p "${CARGO_HOME}/bin" || die

	for tool in "${tools[@]}"; do
		local symlink_path="${CARGO_HOME}/bin/${tool}"
		if [[ -e "${symlink_path}" ]]; then
			die "${symlink_path} ${__err_exists}"
		else
			ln -s ${QUIET--v} "${binpath}" "${symlink_path}" || die
		fi
	done

	good "Setting gentoo ${gentoo_rust// /} as default toolchain"
	[[ ${QUIET+set} != set ]] && "${CARGO_HOME}/bin/rustup" -V
	"${CARGO_HOME}/bin/rustup" ${QUIET--v} toolchain link gentoo "/usr"
	"${CARGO_HOME}/bin/rustup" ${QUIET--v} default gentoo
	[[ ${QUIET+set} != set ]] && "${CARGO_HOME}/bin/rustup" show

	good "Prepend ${CARGO_HOME}/bin to your PATH to use rustup"
	good "rustup selfupdate is disabled, it will be updated by portage"
} # symlink_rustup()

unsymlink_rustup() {
	local symlinks
	IFS= mapfile -d '' symlinks < <(find -L "${CARGO_HOME}/bin" \
		-samefile "${binpath}" -print0 )
	if [[ "${symlinks-}" ]]; then
		rm -v "${symlinks[@]}" || die
	else
		die "already clean"
	fi
}

main(){
	[[ "$EUID" -eq 0 ]] && die "Running as root is not supported"
	local me
	me="$(basename "${BASH_SOURCE[${#BASH_SOURCE[@]} - 1]}")"

	local symlink=no
	local unsymlink=no

	while [[ ${#} -gt 0 ]]; do
		case ${1} in
			-s|--symlink)
				symlink=yes
				;;
			-u|--unsymlink)
				unsymlink=yes
				;;
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
	if [[ ${symlink} == yes ]]; then
		symlink_rustup
	elif [[ ${unsymlink} == yes ]]; then
		unsymlink_rustup
	else
		help
	fi
} # main()


main "${@}"
