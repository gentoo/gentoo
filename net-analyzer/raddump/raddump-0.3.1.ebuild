# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="RADIUS packet interpreter"
HOMEPAGE="https://sourceforge.net/projects/raddump/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND=">=net-analyzer/tcpdump-3.8.3-r1"
DEPEND=${RDEPEND}

src_prepare() {
	default
	eautoreconf
}
