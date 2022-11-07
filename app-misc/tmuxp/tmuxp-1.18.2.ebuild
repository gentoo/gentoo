# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
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
	=dev-python/libtmux-0.15*[${PYTHON_USEDEP}]
	>=dev-python/libtmux-0.15.9[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.3.9[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-6.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		>=dev-python/pytest-rerunfailures-4.2[${PYTHON_USEDEP}]
		>=dev-python/tomli-1.1.0[${PYTHON_USEDEP}]
		!dev-python/flaky
	)
"

distutils_enable_tests pytest

python_test() {
	SHELL="/bin/bash" epytest tests
}
