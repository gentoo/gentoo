# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Nice, highly configurable WMaker DockApp that monitors your mail boxes"
HOMEPAGE="http://peephole.sourceforge.net/"
SRC_URI="mirror://sourceforge/peephole/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~sparc x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXt
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	>=net-mail/peephole-1.2"

pkg_postinst() {
	einfo "Before you can use wmpeople you must copy"
	einfo "/etc/skel/.wmpeoplerc to your home dir"
	einfo "and edit it to suit your needs."
	einfo "Also, make sure that the peephole daemon"
	einfo "is up and running before you start wmpeople."
}
