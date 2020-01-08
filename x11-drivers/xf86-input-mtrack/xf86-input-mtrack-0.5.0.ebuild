# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vcs-snapshot

DESCRIPTION="Xorg Driver for Multitouch Trackpads"
HOMEPAGE="https://github.com/p2rkw/xf86-input-mtrack"
SRC_URI="https://github.com/p2rkw/xf86-input-mtrack/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"
IUSE="debug"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"

RDEPEND=">=sys-libs/mtdev-1.0
	x11-base/xorg-server:="
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

DOCS=( "README.md" )

src_configure() {
	econf \
		$(use_enable debug)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
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
