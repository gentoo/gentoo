# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=pdm-backend

inherit distutils-r1 eapi9-pipestatus shell-completion pypi

DESCRIPTION="Build great CLIs. Easy to code. Based on Python type hints."
HOMEPAGE="
	https://typer.tiangolo.com/
	https://github.com/tiangolo/typer
	https://pypi.org/project/typer/
"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="+rich shell-detection test"

BDEPEND="
	test? (
		dev-python/shellingham[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	rich? ( dev-python/rich[${PYTHON_USEDEP}] )
	shell-detection? ( dev-python/shellingham[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest

typer_get_comp() {
	local COMPLETIONSDIR="${WORKDIR}/comp"
	local shell="$1"

	case "${shell}" in
		bash) echo "${COMPLETIONSDIR}/${PN}" ;;
		zsh)  echo "${COMPLETIONSDIR}/_${PN}" ;;
		fish) echo "${COMPLETIONSDIR}/${PN}.fish" ;;
		*)    die "unknown shell: ${shell}" ;;
	esac
}

typer_gencomp() {
	local COMPLETIONSDIR="${WORKDIR}/comp"
	mkdir "${COMPLETIONSDIR}" 2> /dev/null
	local shell="$1"

	compfile="$(typer_get_comp "${@}")"

	_TYPER_COMPLETE_TEST_DISABLE_SHELL_DETECTION=1 python -m typer --show-completion "${shell}" |
		sed 's/python -m //g ; s/_PYTHON _M //g ; s/python_m//g ; s/TYPER_COMPLETE/_TYPER_COMPLETE/' > "${compfile}"
	pipestatus || die "failed to generate ${shell} completion"

	einfo "generated completion script for ${shell}: ${compfile}"
}

python_compile() {
	local shell
	for shell in bash zsh fish; do
		typer_gencomp ${shell}
	done
	distutils-r1_python_compile
}

python_test() {
	# See scripts/tests.sh
	local -x TERMINAL_WIDTH=3000 _TYPER_FORCE_DISABLE_TERMINAL=1  _TYPER_RUN_INSTALL_COMPLETION_TESTS=1
	epytest
}

src_install() {
	dobashcomp "$(typer_get_comp bash)"
	dozshcomp "$(typer_get_comp zsh)"
	dofishcomp "$(typer_get_comp fish)"

	distutils-r1_src_install
}
