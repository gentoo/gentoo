# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

MY_P=${PN}2-${PV}

DESCRIPTION="Active OS fingerprinting tool - this is Xprobe2"
HOMEPAGE="http://sys-security.com/blog/xprobe2"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"

DEPEND="net-libs/libpcap"
RDEPEND="${DEPEND}"
PATCHES=(
	"${FILESDIR}"/${P}-gcc43.patch
	"${FILESDIR}"/${P}-cxx11.patch
)
S=${WORKDIR}/${MY_P}

src_prepare() {
	default
	sed -i -e 's:strip:true:' src/Makefile.in || die
	sed -i -e 's:ar cr:$(AR) cr:g' $(find -name '*Makefile*') || die

	tc-export AR
}

src_install() {
	default
	dodoc AUTHORS CHANGELOG CREDITS README TODO docs/*.{txt,pdf}
}
