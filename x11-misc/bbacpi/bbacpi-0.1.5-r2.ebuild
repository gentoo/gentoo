# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/bbacpi/bbacpi-0.1.5-r2.ebuild,v 1.2 2014/07/02 00:15:38 jer Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="ACPI monitor for X11"
HOMEPAGE="http://bbacpi.sourceforge.net"
SRC_URI="mirror://sourceforge/bbacpi/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-libs/imlib
	sys-power/acpi
	sys-power/acpid
	x11-libs/libX11
	x11-misc/xdialog
"
RDEPEND="
	${DEPEND}
	media-fonts/font-adobe-100dpi
"

DOCS=( AUTHORS ChangeLog README )

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-noextraquals.diff \
		"${FILESDIR}"/${P}-overflows.diff
	eautoreconf
}
