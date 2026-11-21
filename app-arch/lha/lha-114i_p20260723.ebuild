# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit autotools flag-o-matic

MY_COMMIT="16619b066b189ef289bb8b07b37d1c38d550da99"

DESCRIPTION="Utility for creating and opening lzh archives"
HOMEPAGE="https://github.com/jca02266/lha https://lha.osdn.jp"
SRC_URI="https://github.com/jca02266/lha/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="lha"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~ppc ~ppc64 ~s390 ~sparc ~x86"

DEPEND="virtual/libiconv"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P/_p*}-file-list-from-stdin.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-cflags -std=gnu17 #bug #943900
	econf
}

src_install() {
	default
	dodoc olddoc/ChangeLog Hacking_of_LHa
}
