# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/bbacpi/bbacpi-0.1.5-r1.ebuild,v 1.4 2012/11/25 10:15:03 xarthisius Exp $

EAPI=2

inherit eutils

DESCRIPTION="ACPI monitor for X11"
HOMEPAGE="http://bbacpi.sourceforge.net"
SRC_URI="mirror://sourceforge/bbacpi/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND="x11-libs/gtk+:2
	media-libs/imlib
	x11-misc/xdialog
	sys-power/acpi
	sys-power/acpid"
RDEPEND="${DEPEND}
	media-fonts/font-adobe-100dpi"

src_prepare() {
	epatch "${FILESDIR}"/${P}-noextraquals.diff
}

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog README || die
}
