# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Python bindings for the low-level FUSE API"
HOMEPAGE="
	https://github.com/python-llfuse/python-llfuse/
	https://pypi.org/project/llfuse/
"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"
IUSE="doc examples"

RDEPEND="
	>=sys-fs/fuse-2.8.0:0
"
DEPEND="
	${RDEPEND}
	sys-apps/attr
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/llfuse-1.3.5-cflags.patch
)

distutils_enable_sphinx rst
EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_prepare() {
	# force regen
	rm src/llfuse.c || die
	distutils-r1_src_prepare
}

python_compile() {
	if [[ ! -f src/llfuse.c ]]; then
		esetup.py build_cython
	fi
	distutils-r1_python_compile
}

python_install_all() {
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
