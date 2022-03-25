# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Python bindings for libgit2"
HOMEPAGE="
	https://github.com/libgit2/pygit2/
	https://pypi.org/project/pygit2/"
SRC_URI="
	https://github.com/libgit2/pygit2/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="GPL-2-with-linking-exception"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	=dev-libs/libgit2-1.4*:=
"
BDEPEND="
	>=dev-python/cffi-1.9.1:=[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
	${BDEPEND}
"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# unconditionally prevent it from using network
	sed -i -e '/has_network/s:True:False:' test/utils.py || die
}

src_test() {
	rm -r pygit2 || die
	distutils-r1_src_test
}
