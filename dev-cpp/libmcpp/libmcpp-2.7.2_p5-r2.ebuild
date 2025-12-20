# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

MY_PN=${PN/lib/}
MY_P=$(ver_cut 1-4 ${MY_PN}-${PV})

DESCRIPTION="A portable C++ preprocessor"
HOMEPAGE="http://mcpp.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/mcpp/${MY_P}.tar.gz"
SRC_URI+=" mirror://debian/pool/main/m/${MY_PN}/${MY_PN}_${PV/_p/-}.debian.tar.xz"
S="${WORKDIR}"/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv x86 ~x64-macos"

PATCHES=(
	# bug #718808
	"${WORKDIR}"/debian/patches/

	"${FILESDIR}"/${PN}-2.7.2-fix-build-system.patch
	"${FILESDIR}"/${PN}-2.7.2-fix-configure-checks.patch
	"${FILESDIR}"/${PN}-2.7.2-incompatible-pointer-types.patch
	"${FILESDIR}"/mcpp-c99.patch
)

src_prepare() {
	default

	# bug #778461
	sed -i 's/-lmcpp/libmcpp.la/' src/Makefile.am || die

	eautoreconf
}

src_configure() {
	# bug #944370
	append-cflags -std=gnu17

	econf --enable-mcpplib
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
