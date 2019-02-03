# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: show content of menu in a shell window"
HOMEPAGE="http://www.tvdr.de/"
SRC_URI="mirror://gentoo/${P}.tar.gz
		https://dev.gentoo.org/~hd_brummy/distfiles/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-2.2.0"
