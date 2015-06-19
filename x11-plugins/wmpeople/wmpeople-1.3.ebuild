# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmpeople/wmpeople-1.3.ebuild,v 1.7 2014/09/01 13:35:51 voyageur Exp $

inherit eutils

DESCRIPTION="Nice, highly configurable WMaker DockApp that monitors your mail boxes"
HOMEPAGE="http://peephole.sourceforge.net/"
SRC_URI="mirror://sourceforge/peephole/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc ~sparc"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXt
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto
	>=net-mail/peephole-1.2"

src_install() {
	emake DESTDIR="${D}" install || die "Installation failed"
	dodoc AUTHORS ChangeLog README
}

pkg_postinst() {
	einfo "Before you can use wmpeople you must copy"
	einfo "/etc/skel/.wmpeoplerc to your home dir"
	einfo "and edit it to suit your needs."
	einfo "Also, make sure that the peephole daemon"
	einfo "is up and running before you start wmpeople."
}
