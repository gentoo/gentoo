# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/m17n-lib/m17n-lib-1.5.4.ebuild,v 1.3 2012/12/03 07:13:23 naota Exp $

EAPI=2
inherit flag-o-matic

DESCRIPTION="Multilingual Library for Unix/Linux"
HOMEPAGE="https://savannah.nongnu.org/projects/m17n"
SRC_URI="http://www.m17n.org/m17n-lib-download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
#IUSE="anthy gd ispell"
IUSE="gd"

RDEPEND="x11-libs/libXaw
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXrender
	x11-libs/libXft
	dev-libs/libxml2
	dev-libs/fribidi
	>=media-libs/freetype-2.1
	media-libs/fontconfig
	gd? ( media-libs/gd[png] )
	>=dev-libs/libotf-0.9.4
	>=dev-db/m17n-db-${PV}"
# linguas_th? ( || ( app-i18n/libthai app-i18n/wordcut ) )
# anthy? ( app-i18n/anthy )
# ispell? ( app-text/ispell )

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	append-flags -fPIC
	econf $(use_with gd) || die
}

src_compile() {
	emake -j1 || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog NEWS README TODO
}
