# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils multilib

DESCRIPTION="A multi-protocol instant messaging client"
HOMEPAGE="http://ayttm.sourceforge.net/"
SRC_URI="mirror://sourceforge/ayttm/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="crypt icq irc xmpp lj msn nls oscar smtp webcam xscreensaver yahoo"

CDEPEND="app-text/enchant
	dev-libs/glib:2
	dev-libs/openssl:0
	virtual/libiconv
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXpm
	x11-libs/pango
	crypt? ( app-crypt/gpgme )
	webcam? ( media-libs/jasper )
	xscreensaver? ( x11-libs/libXScrnSaver )
	yahoo? ( net-libs/libyahoo2 )"
RDEPEND="${CDEPEND}
	webcam? ( media-tv/xawtv )"
DEPEND="${CDEPEND}
	sys-devel/bison
	sys-devel/flex
	nls? ( sys-devel/gettext )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-opt-xscreensaver.patch \
		"${FILESDIR}"/${P}-opt-webcam.patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable crypt aycryption) \
		--disable-esd \
		$(use_enable icq) \
		$(use_enable irc) \
		$(use_enable xmpp jabber) \
		$(use_enable lj) \
		$(use_enable msn) \
		$(use_enable nls) \
		$(use_enable oscar) \
		$(use_enable smtp) \
		$(use_enable webcam) \
		$(use_enable xscreensaver) \
		$(use_enable yahoo) \
		--disable-arts \
		--enable-posix-dlopen \
		--disable-static
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog README README.LINUX TODO
	rm -f "${D}"/usr/$(get_libdir)/${PN}/*.la
}
