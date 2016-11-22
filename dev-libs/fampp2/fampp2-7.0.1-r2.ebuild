# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools flag-o-matic

DESCRIPTION="C++ wrapper for fam"
HOMEPAGE="https://sourceforge.net/projects/fampp/"
SRC_URI="mirror://sourceforge/fampp/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples stlport"

RDEPEND="virtual/fam
	stlport? ( dev-libs/STLport )
	>=dev-libs/ferrisloki-2.0.3[stlport?]
	>=dev-libs/libsigc++-2.6:2
	dev-libs/glib:2
	x11-libs/gtk+:2"
DEPEND="${DEPEND}
	virtual/pkgconfig"

PATCHES=(
	# Fix compat with libsigc++-2.6, #569700
	"${FILESDIR}/${PN}-7.0.1-libsigc++-2.6.patch"
	# Fix completely broken buildsystem
	"${FILESDIR}/${PN}-7.0.1-fix-buildsystem.patch"
	# Fix noexcept(true) for dtors in >=C++11 with GCC 6, #595308
	"${FILESDIR}/${PN}-7.0.1-fix-gcc6.patch"
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	# libsigc++-2.6 requires building with C++11
	append-cxxflags -std=c++11

	# glib and gtk+ are only required for some examples
	econf \
		--disable-static \
		--disable-glibtest \
		--disable-gtktest \
		--with-stlport="${EPREFIX}/usr/include/stlport" \
		$(use_enable stlport) \
		$(use_with examples)
}

src_install() {
	default

	# package provides .pc files
	find "${D}" -name '*.la' -delete || die
}
