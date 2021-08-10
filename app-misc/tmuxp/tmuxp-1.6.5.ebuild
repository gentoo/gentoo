# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..8} pypy3 )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="tmux session manager. built on libtmux"
HOMEPAGE="https://tmuxp.git-pull.com"
SRC_URI="https://github.com/tmux-python/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="test"

RDEPEND="
	>=app-misc/tmux-3.0a
	>=dev-python/kaptan-0.5.10[${PYTHON_USEDEP}]
	>=dev-python/libtmux-0.8.5[${PYTHON_USEDEP}]
	<dev-python/libtmux-0.9[${PYTHON_USEDEP}]
	>=dev-python/click-7.0[${PYTHON_USEDEP}]
	<dev-python/click-8.0[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.3.9[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}
	test? (
		>=dev-python/pytest-4.1.1[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		>=dev-python/pytest-rerunfailures-4.2[${PYTHON_USEDEP}]
		!dev-python/flaky
	)
"

PATCHES=(
	"${FILESDIR}/tmuxp-1.6.4-tests.patch"
)

distutils_enable_tests pytest

python_test() {
	SHELL="/bin/bash" pytest -vv || die "Tests fail with ${EPYTHON}"
}
