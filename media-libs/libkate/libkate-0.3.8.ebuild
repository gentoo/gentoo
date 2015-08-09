# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
PYTHON_DEPEND="wxwidgets? 2"
inherit python

DESCRIPTION="Codec for karaoke and text encapsulation for Ogg"
HOMEPAGE="http://code.google.com/p/libkate/"
SRC_URI="http://libkate.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="debug doc wxwidgets"

COMMON_DEPEND="media-libs/libogg
	media-libs/libpng"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	sys-devel/flex
	sys-devel/bison
	doc? ( app-doc/doxygen )"
RDEPEND="${COMMON_DEPEND}
	wxwidgets? ( =dev-python/wxpython-2.8* media-libs/liboggz )"

pkg_setup() {
	if use wxwidgets; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_prepare() {
	use wxwidgets && python_clean_py-compile_files
}

src_configure() {
	use wxwidgets || sed -i -e "s/HAVE_PYTHON=yes/HAVE_PYTHON=no/" configure
	econf $(use_enable debug) $(use_enable doc) --docdir=/usr/share/doc/${PF}
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog README
	use wxwidgets && python_convert_shebangs -r 2 "${D}"
}

pkg_postinst() {
	use wxwidgets && python_mod_optimize kdj
}

pkg_postrm() {
	use wxwidgets && python_mod_cleanup kdj
}
