# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
