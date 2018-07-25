# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A plugin which enables text-to-speech output of conversations using festival"
HOMEPAGE="https://sourceforge.net/projects/pidgin-festival/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="
	app-accessibility/festival
	net-im/pidgin[gtk]
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
