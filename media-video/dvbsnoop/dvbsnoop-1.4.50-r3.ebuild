# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="DVB/MPEG stream analyzer program"
HOMEPAGE="https://sourceforge.net/projects/dvbsnoop/"
SRC_URI="mirror://sourceforge/dvbsnoop/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="sys-kernel/linux-headers"

PATCHES=(
	"${FILESDIR}"/${P}-crc32.patch
)

src_configure(){
	default
	eautoreconf
}

src_compile(){
	emake AR="$(tc-getAR)"
}
