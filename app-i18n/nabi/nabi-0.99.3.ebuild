# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/nabi/nabi-0.99.3.ebuild,v 1.5 2014/05/14 15:31:03 tomwij Exp $

EAPI="5"

inherit eutils autotools

DESCRIPTION="Simple Hanguk X Input Method"
HOMEPAGE="https://code.google.com/p/nabi/"
SRC_URI="http://kldp.net/frs/download.php/4929/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND=">=app-i18n/libhangul-0.0.8
	dev-libs/glib:2
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-2.4:2
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/pango"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-asneeded.patch

	eautoreconf
}

src_configure() {
	local myconf=

	# Broken configure: --disable-debug also enables debug
	use debug && \
		myconf="${myconf} --enable-debug"

	econf ${myconf}
}

pkg_postinst() {
	elog "You MUST add environment variable..."
	elog
	elog "export XMODIFIERS=\"@im=nabi\""
	elog
}
