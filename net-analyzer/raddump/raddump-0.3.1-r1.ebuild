# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="RADIUS packet interpreter"
HOMEPAGE="https://sourceforge.net/projects/raddump/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

RDEPEND=">=net-analyzer/tcpdump-3.8.3-r1"
DEPEND=${RDEPEND}

PATCHES=( "${FILESDIR}/${P}-gcc14.patch" )

src_prepare() {
	default
	eautoreconf
}
