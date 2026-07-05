# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: shell-completion.eclass
# @MAINTAINER:
# Jonas Frei <freijon@pm.me>
# Florian Schmaus <flow@gentoo.org>
# mgorny@gentoo.org
# @AUTHOR:
# Alfred Wingate <parona@protonmail.com>
# @SUPPORTED_EAPIS: 7 8 9
# @BLURB: a few quick functions to install various shell completion files
# @DESCRIPTION:
# This eclass provides a standardised way to install shell completions
# for popular shells.

case ${EAPI} in
	7|8|9) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported"
esac

if [[ -z ${_SHELL_COMPLETION_ECLASS} ]]; then
_SHELL_COMPLETION_ECLASS=1

if [[ ${EAPI} != 9 ]]; then
inherit toolchain-funcs
fi

# @FUNCTION: _bash-completion-r1_get_bashdir
# @INTERNAL
# @DESCRIPTION:
# First argument is name of the string in bash-completion.pc
# Second argument is the fallback directory if the string is not found
# Note that the first argument is only used on EAPI < 9.
# @EXAMPLE:
# _bash-completion-r1_get_bashdir completionsdir /usr/share/bash-completion
_bash-completion-r1_get_bashdir() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${EAPI} != 9 ]] && $(tc-getPKG_CONFIG) --exists bash-completion &>/dev/null; then
		local path
		path=$($(tc-getPKG_CONFIG) --variable="${1}" bash-completion) || die
		# we need to return unprefixed, so strip from what pkg-config returns
		# to us, bug #477692
		echo "${path#"${EPREFIX}"}"
		return
	fi

	echo "${2}"
}

# @FUNCTION: _bash-completion-r1_get_bashcompdir
# @INTERNAL
# @DESCRIPTION:
# Get unprefixed bash-completion completions directory.
_bash-completion-r1_get_bashcompdir() {
	debug-print-function ${FUNCNAME} "$@"

	_bash-completion-r1_get_bashdir completionsdir /usr/share/bash-completion/completions
}

# @FUNCTION: _bash-completion-r1_get_bashhelpersdir
# @INTERNAL
# @DESCRIPTION:
# Get unprefixed bash-completion helpers directory.
_bash-completion-r1_get_bashhelpersdir() {
	debug-print-function ${FUNCNAME} "$@"

	_bash-completion-r1_get_bashdir helpersdir /usr/share/bash-completion/helpers
}

# @FUNCTION: get_bashcompdir
# @DESCRIPTION:
# Get the bash-completion completions directory.
get_bashcompdir() {
	debug-print-function ${FUNCNAME} "$@"

	echo "${EPREFIX}$(_bash-completion-r1_get_bashcompdir)"
}

# @FUNCTION: get_bashhelpersdir
# @INTERNAL
# @DESCRIPTION:
# Get the bash-completion helpers directory.
get_bashhelpersdir() {
	debug-print-function ${FUNCNAME} "$@"

	echo "${EPREFIX}$(_bash-completion-r1_get_bashhelpersdir)"
}

# @FUNCTION: dobashcomp
# @USAGE: <file> [...]
# @DESCRIPTION:
# Install bash-completion files passed as args. Has EAPI-dependent failure
# behavior (like doins).
dobashcomp() {
	debug-print-function ${FUNCNAME} "$@"

	(
		insopts -m 0644
		insinto "$(_bash-completion-r1_get_bashcompdir)"
		doins "${@}"
	)
}

# @FUNCTION: newbashcomp
# @USAGE: <file> <newname>
# @DESCRIPTION:
# Install bash-completion file under a new name. Has EAPI-dependent failure
# behavior (like newins).
newbashcomp() {
	debug-print-function ${FUNCNAME} "$@"

	(
		insopts -m 0644
		insinto "$(_bash-completion-r1_get_bashcompdir)"
		newins "${@}"
	)
}

# @FUNCTION: bashcomp_alias
# @USAGE: <basename> <alias>...
# @DESCRIPTION:
# Alias <basename> completion to one or more commands (<alias>es).
bashcomp_alias() {
	debug-print-function ${FUNCNAME} "$@"

	[[ ${#} -lt 2 ]] && die "Usage: ${FUNCNAME} <basename> <alias>..."
	local base=${1} f
	shift

	for f; do
		dosym "${base}" "$(_bash-completion-r1_get_bashcompdir)/${f}" \
			|| return
	done
}

# @FUNCTION: _shell-completion_get_fishcompdir
# @INTERNAL
# @RETURN: unprefixed fish completions directory
_shell-completion_get_fishcompdir() {
	echo "/usr/share/fish/vendor_completions.d"
}

# @FUNCTION: _shell-completion_get_zshcompdir
# @INTERNAL
# @RETURN: unprefixed zsh completions directory
_shell-completion_get_zshcompdir() {
	echo "/usr/share/zsh/site-functions"
}

# @FUNCTION: get_fishcompdir
# @RETURN: the fish completions directory (with EPREFIX)
get_fishcompdir() {
	debug-print-function ${FUNCNAME} "$@"

	echo "${EPREFIX}$(_shell-completion_get_fishcompdir)"
}

# @FUNCTION: get_zshcompdir
# @RETURN: the zsh completions directory (with EPREFIX)
get_zshcompdir() {
	debug-print-function ${FUNCNAME} "$@"

	echo "${EPREFIX}$(_shell-completion_get_zshcompdir)"
}

# @FUNCTION: dofishcomp
# @USAGE: <file...>
# @DESCRIPTION:
# Install fish completion files passed as args.
dofishcomp() {
	debug-print-function ${FUNCNAME} "$@"

	(
		insopts -m 0644
		insinto "$(_shell-completion_get_fishcompdir)"
		doins "${@}"
	)
}

# @FUNCTION: dozshcomp
# @USAGE: <file...>
# @DESCRIPTION:
# Install zsh completion files passed as args.
dozshcomp() {
	debug-print-function ${FUNCNAME} "$@"

	(
		insopts -m 0644
		insinto "$(_shell-completion_get_zshcompdir)"
		doins "${@}"
	)
}

# @FUNCTION: newfishcomp
# @USAGE: <file> <newname>
# @DESCRIPTION:
# Install fish file under a new name.
newfishcomp() {
	debug-print-function ${FUNCNAME} "$@"

	(
		insopts -m 0644
		insinto "$(_shell-completion_get_fishcompdir)"
		newins "${@}"
	)
}

# @FUNCTION: newzshcomp
# @USAGE: <file> <newname>
# @DESCRIPTION:
# Install zsh file under a new name.
newzshcomp() {
	debug-print-function ${FUNCNAME} "$@"

	(
		insopts -m 0644
		insinto "$(_shell-completion_get_zshcompdir)"
		newins "${@}"
	)
}

fi
