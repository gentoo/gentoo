# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

MY_COMMIT="26950220c9c7590fd603ecaa54a12a52371affed"

DESCRIPTION="Utility for creating and opening lzh archives"
HOMEPAGE="https://github.com/jca02266/lha https://lha.osdn.jp"
SRC_URI="https://github.com/jca02266/lha/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="lha"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~m68k ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

S="${WORKDIR}/${PN}-${MY_COMMIT}"

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
