# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit autotools-utils eutils ltprune python-r1

DESCRIPTION="Python bindings for libnotify"
HOMEPAGE="http://www.galago-project.org/"
SRC_URI="http://www.galago-project.org/files/releases/source/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~ia64 ~mips ppc ~ppc64 sparc x86"
IUSE="examples"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-python/pygtk-2.24:2[${PYTHON_USEDEP}]
	>=x11-libs/libnotify-0.7"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-libnotify-0.7.patch )

src_prepare() {
	# Remove the old pynotify.c to ensure it's properly regenerated #212128.
	rm -f src/pynotify.c || die
	autotools-utils_src_prepare
}

src_configure() {
	python_foreach_impl autotools-utils_src_configure
}

src_compile() {
	python_foreach_impl autotools-utils_src_compile
}

src_test() {
	python_foreach_impl autotools-utils_src_test
}

src_install() {
	python_foreach_impl autotools-utils_src_install
	prune_libtool_files --all

	# Requested from bug 351879.
	if use examples; then
		docinto examples
		dodoc tests/*.{png,py}
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
