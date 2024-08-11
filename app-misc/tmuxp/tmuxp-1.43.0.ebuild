# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )
DISTUTILS_USE_PEP517=poetry
inherit distutils-r1

DESCRIPTION="tmux session manager. built on libtmux"
HOMEPAGE="https://tmuxp.git-pull.com"
SRC_URI="https://github.com/tmux-python/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

RDEPEND="
	>=app-misc/tmux-3.0a
	=dev-python/libtmux-0.35*[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.3.9[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-6.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		>=dev-python/pytest-rerunfailures-4.2[${PYTHON_USEDEP}]
		!dev-python/flaky
	)
"

EPYTEST_DESELECT=(
	# test doesn't get along with sandbox
	"tests/cli/test_load.py::test_load_zsh_autotitle_warning"
)

EPYTEST_IGNORE=(
	# not actually tests, but throws off test collection
	"tests/fixtures/"
)

distutils_enable_tests pytest

python_prepare_all() {
	sed -r -e 's:libtmux = "~[0-9.]+":libtmux = "~0.30":' \
		-i pyproject.toml || die

	distutils-r1_python_prepare_all
}

python_test() {
	SHELL="/bin/bash" epytest tests
}
