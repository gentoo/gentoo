# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit ltprune python-single-r1

DESCRIPTION="Codec for karaoke and text encapsulation for Ogg"
HOMEPAGE="https://code.google.com/p/libkate/"
SRC_URI="https://libkate.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"

IUSE="debug doc wxwidgets"
REQUIRED_USE="wxwidgets? ( ${PYTHON_REQUIRED_USE} )"

COMMON_DEPEND="
	media-libs/libogg:=
	media-libs/libpng:0=
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	sys-devel/flex
	sys-devel/bison
	doc? ( app-doc/doxygen )
"
RDEPEND="${COMMON_DEPEND}
	wxwidgets? (
		${PYTHON_DEPS}
		dev-python/wxpython:3.0[${PYTHON_USEDEP}]
		media-libs/liboggz )
"

pkg_setup() {
	use wxwidgets && python-single-r1_pkg_setup
}

src_configure() {
	if ! use wxwidgets; then
		sed -i -e "s/HAVE_PYTHON=yes/HAVE_PYTHON=no/" configure || die
	fi

	econf --disable-static $(use_enable debug) $(use_enable doc)
}

src_install() {
	default
	prune_libtool_files
	use wxwidgets && python_fix_shebang "${D}"
}
