# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-input-mtrack/xf86-input-mtrack-0.3.1.ebuild,v 1.1 2015/03/26 17:19:19 chithanh Exp $

EAPI=5

XORG_EAUTORECONF=yes

inherit xorg-2 vcs-snapshot

DESCRIPTION="Xorg Driver for Multitouch Trackpads"
HOMEPAGE="https://github.com/BlueDragonX/xf86-input-mtrack"
SRC_URI="http://github.com/BlueDragonX/xf86-input-mtrack/tarball/v${PV/_/-} -> ${P}.tar.gz"
IUSE="debug"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RDEPEND="${RDEPEND}
	>=sys-libs/mtdev-1.0"
DEPEND="${DEPEND}
	>=sys-libs/mtdev-1.0
	x11-proto/randrproto
	x11-proto/videoproto
	x11-proto/xineramaproto"

DOCS=( "README.md" )
PATCHES=( "${FILESDIR}"/${PN}-0.2.0-drop-mtrack-test.patch )

pkg_setup() {
	xorg-2_pkg_setup
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable debug)
	)
}

pkg_postinst() {
	xorg-2_pkg_postinst

	elog
	elog "To enable multitouch support add the following lines"
	elog "to your xorg.conf:"
	elog ""
	elog "Section \"InputClass\""
	elog "  MatchIsTouchpad \"true\""
	elog "  Identifier      \"Touchpads\""
	elog "  Driver          \"mtrack\""
	elog "EndSection"
	elog
}
