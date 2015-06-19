# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/m17n-lib/m17n-lib-1.6.2.ebuild,v 1.4 2012/12/03 07:13:23 naota Exp $

EAPI=4

inherit eutils autotools

DESCRIPTION="Multilingual Library for Unix/Linux"
HOMEPAGE="https://savannah.nongnu.org/projects/m17n"
SRC_URI="http://www.m17n.org/m17n-lib-download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
#IUSE="anthy gd ispell"
IUSE="gd X"

RDEPEND="
	X? (
		x11-libs/libXaw
		x11-libs/libXft
		x11-libs/libX11
		gd? ( media-libs/gd[png] )
		dev-libs/fribidi
		>=media-libs/freetype-2.1
		media-libs/fontconfig
		>=dev-libs/libotf-0.9.4
	)
	dev-libs/libxml2
	~dev-db/m17n-db-${PV}"
# linguas_th? ( || ( app-i18n/libthai app-i18n/wordcut ) )
# anthy? ( app-i18n/anthy )
# ispell? ( app-text/ispell )

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gui.patch \
		"${FILESDIR}"/${P}-parallel-make.patch \
		"${FILESDIR}"/${P}-candidates-list.patch

	eautoreconf
}

src_configure() {
	local myconf=

	if use X; then
		myconf+=" --enable-gui $(use_with gd)"
	else
		myconf+=" --disable-gui --without-gd"
	fi

	econf ${myconf} || die
}

src_install() {
	# bug #363239
	emake -j1 DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog NEWS README TODO
}
