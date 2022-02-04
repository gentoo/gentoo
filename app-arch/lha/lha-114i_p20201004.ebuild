# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_COMMIT="7c3cd95fdf0d2f9198bb779561724cd314bc39a6"

DESCRIPTION="Utility for creating and opening lzh archives"
HOMEPAGE="https://github.com/jca02266/lha https://lha.osdn.jp"
SRC_URI="https://github.com/jca02266/lha/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="lha"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~m68k ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

S="${WORKDIR}/${PN}-${MY_COMMIT}"

PATCHES=(
	"${FILESDIR}"/${P/_p*}-file-list-from-stdin.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	if [[ ${CHOST} == *-interix* ]]; then
		export ac_cv_header_inttypes_h=no
		export ac_cv_func_iconv=no
	fi

	default
}

src_install() {
	default
	dodoc olddoc/ChangeLog Hacking_of_LHa
}
