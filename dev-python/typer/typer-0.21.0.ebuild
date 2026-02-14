# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYPI_VERIFY_REPO=https://github.com/fastapi/typer
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 shell-completion pypi

DESCRIPTION="Build great CLIs. Easy to code. Based on Python type hints"
HOMEPAGE="
	https://typer.tiangolo.com/
	https://github.com/fastapi/typer/
	https://pypi.org/project/typer/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64"
IUSE="cli"

RDEPEND="
	>=dev-python/click-8.0.0[${PYTHON_USEDEP}]
	>=dev-python/rich-10.11.0[${PYTHON_USEDEP}]
	>=dev-python/shellingham-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-3.7.4.3[${PYTHON_USEDEP}]
	cli? ( !dev-lang/erlang )
"
BDEPEND="
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
EPYTEST_XDIST=1
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	if ! use cli; then
		sed -i -e '/typer\.cli/d' pyproject.toml || die
	fi
}

python_test() {
	# See scripts/tests.sh
	local -x TERMINAL_WIDTH=3000
	local -x _TYPER_FORCE_DISABLE_TERMINAL=1
	local -x _TYPER_RUN_INSTALL_COMPLETION_TESTS=1

	epytest
}

python_install() {
	if use cli && [[ ! ${COMPLETIONS_INSTALLED} ]]; then
		local -x _TYPER_COMPLETE_TEST_DISABLE_SHELL_DETECTION=1
		newbashcomp - typer < <(typer --show-completion bash || die)
		newzshcomp - typer < <(typer --show-completion zsh || die)
		newfishcomp - typer < <(typer --show-completion fish || die)
		COMPLETIONS_INSTALLED=1
	fi

	distutils-r1_python_install
}
