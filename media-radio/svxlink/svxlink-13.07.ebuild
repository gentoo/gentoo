# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-radio/svxlink/svxlink-13.07.ebuild,v 1.5 2015/03/25 15:59:59 jlec Exp $

EAPI=4
inherit eutils multilib qt4-r2 user

DESCRIPTION="Multi Purpose Voice Services System, including Qtel for EchoLink"
HOMEPAGE="http://svxlink.sourceforge.net/"
SRC_URI="mirror://sourceforge/svxlink/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-lang/tcl:0
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	media-libs/alsa-lib
	media-sound/gsm
	dev-libs/libgcrypt:0
	media-libs/speex
	dev-libs/libsigc++:2
	dev-libs/popt"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

MAKEOPTS="${MAKEOPTS} -j1"

pkg_setup() {
	enewgroup svxlink
	enewuser svxlink -1 -1 -1 svxlink
}

src_prepare() {
	sed -i -e "s:/lib:/$(get_libdir):g" makefile.cfg || die
	sed -i -e "s:/etc/udev:/lib/udev:" svxlink/scripts/Makefile.default || die
	# fix underlinking
	sed -i -e "s:lgsm:lgsm -lspeex:" qtel/Makefile.default || die
	# drop deprecated desktop category (bug #475730)
	sed -i -e "s:Categories=Application;:Categories=:g" qtel/qtel.desktop || die
}

src_install() {
	default

	fowners -R svxlink.svxlink /var/spool/svxlink
	# adapt to gentoo init system
	rm -R "${D}"/etc/sysconfig || die
	newinitd "${FILESDIR}"/remotetrx.init remotetrx
	newinitd "${FILESDIR}"/svxlink.init svxlink
	newconfd "${FILESDIR}"/remotetrx.rc remotetrx
	newconfd "${FILESDIR}"/svxlink.rc svxlink
}
