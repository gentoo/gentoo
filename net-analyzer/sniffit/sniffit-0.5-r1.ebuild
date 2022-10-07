# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Interactive Packet Sniffer"
HOMEPAGE="https://github.com/resurrecting-open-source-projects/sniffit"
SRC_URI="https://github.com/resurrecting-open-source-projects/sniffit/archive/${P}.tar.gz"
S="${WORKDIR}"/${PN}-${P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

RDEPEND="
	net-libs/libpcap
	>=sys-libs/ncurses-5.2
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.4.0-tinfo.patch
	"${FILESDIR}"/${PN}-0.5.0-implicit-func-decl.patch
)

src_prepare() {
	default
	eautoreconf
}
