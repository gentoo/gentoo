# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1 eapi7-ver

DESCRIPTION="Python bindings for libgit2"
HOMEPAGE="https://github.com/libgit2/pygit2 https://pypi.org/project/pygit2/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2-with-linking-exception"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	=dev-libs/libgit2-$(ver_cut 1-2)*
	>=dev-python/cffi-1.0:=[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

src_prepare() {
	distutils-r1_src_prepare

	# we need to move them away to prevent pytest from forcing '..'
	# for imports
	mkdir hack || die
	mv test hack/ || die
	ln -s hack/test test || die
}

python_test() {
	pytest -vv hack/test || die
}
