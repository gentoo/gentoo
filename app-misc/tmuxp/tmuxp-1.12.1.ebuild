# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} pypy3 )
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
	>=dev-python/kaptan-0.5.10[${PYTHON_USEDEP}]
	~dev-python/libtmux-0.12.0[${PYTHON_USEDEP}]
	>=dev-python/click-8.0[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.3.9[${PYTHON_USEDEP}]
	dev-python/pathspec[${PYTHON_USEDEP}]
	>=dev-python/tomli-1.1.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/pytest-rerunfailures-4.2[${PYTHON_USEDEP}]
		!dev-python/flaky
	)
"

PATCHES=(
	"${FILESDIR}/tmuxp-1.7.2-tests.patch"
	"${FILESDIR}/tmuxp-1.9.2-tests.patch"
)

distutils_enable_tests pytest

python_test() {
	SHELL="/bin/bash" epytest
}
