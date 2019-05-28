# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="A mail notification program"
HOMEPAGE="http://gnubiff.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug fam nls password"

RDEPEND="
	>=x11-libs/gtk+-3:3
	>=gnome-base/libglade-2.3
	dev-libs/popt
	password? ( dev-libs/openssl:0= )
	fam? ( virtual/fam )
	x11-libs/libX11
	x11-libs/pango
	x11-libs/gdk-pixbuf
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

DOCS="AUTHORS ChangeLog NEWS README THANKS TODO"

src_prepare() {
	eapply -p0 "${FILESDIR}/${PN}-2.2.15-fix-nls.patch"
	eapply -p1 "${FILESDIR}/${PN}-2.2.15-gold.patch"
	eapply -p0 "${FILESDIR}/${PN}-2.2.15-underlink.patch"
	eautoreconf
	eapply_user
}

src_configure() {
	# note: --disable-gnome is to avoid deprecated gnome-panel-2.x
	econf \
		--disable-gnome \
		$(use_enable debug) \
		$(use_enable nls) \
		$(use_enable fam) \
		$(use_with password) \
		$(use_with password password-string ${RANDOM}${RANDOM}${RANDOM}${RANDOM})
}
