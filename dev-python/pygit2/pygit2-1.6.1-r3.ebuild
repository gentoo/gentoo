# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Python bindings for libgit2"
HOMEPAGE="https://github.com/libgit2/pygit2 https://pypi.org/project/pygit2/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2-with-linking-exception"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	=dev-libs/libgit2-1.1*:=
	>=dev-python/cffi-1.0:=[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# unconditionally prevent it from using network
	sed -i -e '/has_network/s:True:False:' test/utils.py || die

	# we need to move them away to prevent pytest from forcing '..'
	# for imports
	mkdir hack || die
	mv test hack/ || die
	ln -s hack/test test || die
}

python_test() {
	pytest -vv hack/test || die
}
