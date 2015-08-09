# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils autotools

DESCRIPTION="Multilingual Library for Unix/Linux"
HOMEPAGE="https://savannah.nongnu.org/projects/m17n"
SRC_URI="http://download.savannah.gnu.org/releases/m17n/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="anthy athena anthy bidi fontconfig gd spell libotf libxml2 X xft"

RDEPEND="
	anthy? ( app-i18n/anthy )
	spell? ( app-text/aspell )
	libxml2? ( dev-libs/libxml2 )
	X? (
		athena? ( x11-libs/libXaw )
		bidi? ( dev-libs/fribidi )
		fontconfig? ( media-libs/fontconfig )
		gd? ( media-libs/gd[png] )
		libotf? ( >=dev-libs/libotf-0.9.4 )
		xft? (
			>=media-libs/freetype-2.1
			x11-libs/libXft )
		x11-libs/libX11
	)
	~dev-db/m17n-db-${PV}"
# athena? ( x11-libs/libXaw )
# athena shoud be enabled to build m17n-edit properly when X is enabled.

# linguas_th? ( || ( app-i18n/libthai app-i18n/wordcut ) )
#

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-1.6.2-gui.patch \
		"${FILESDIR}"/${PN}-1.6.3-parallel-make.patch \
		"${FILESDIR}"/${PN}-1.6.3-configure.patch \
		"${FILESDIR}"/${PN}-1.6.3-ispell.patch

	eautoreconf
}

src_configure() {
	local myconf="$(use_with anthy) $(use_with spell ispell) $(use_with libxml2)"

	if use X; then
		myconf+=" --with-x --enable-gui $(use_with athena) $(use_with bidi fribidi)
$(use_with fontconfig) $(use_with xft freetype) $(use_with gd) $(use_with libotf)
$(use_with xft)"
	else
		myconf+=" --without-x --disable-gui --without-athena --without-fribidi
--without-fontconfig --without-freetype --without-gd --without-libotf
--without-xft"
	fi

	econf ${myconf} || die
}

src_install() {
	# bug #363239
	emake -j1 DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog NEWS README TODO
}
