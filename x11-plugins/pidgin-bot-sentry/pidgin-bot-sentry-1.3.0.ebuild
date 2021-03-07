# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="${P#pidgin-}"

DESCRIPTION="Bot Sentry is a Pidgin plugin to prevent Instant Message (IM) spam"
HOMEPAGE="http://pidgin-bs.sourceforge.net/"
SRC_URI="mirror://sourceforge/pidgin-bs/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-im/pidgin[gtk]
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
