# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_PN=${PN/lib/}
MY_P=$(ver_cut 1-4 ${MY_PN}-${PV})

DESCRIPTION="A portable C++ preprocessor"
HOMEPAGE="http://mcpp.sourceforge.net"
SRC_URI="mirror://sourceforge/mcpp/${MY_P}.tar.gz"
SRC_URI+=" https://deb.debian.org/debian/pool/main/m/${MY_PN}/${MY_PN}_${PV/_p/-}.debian.tar.xz"
S="${WORKDIR}"/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~x86 ~x86-linux ~x64-macos"

PATCHES=(
	"${FILESDIR}"/${PN}-2.7.2-fix-build-system.patch
)

src_prepare() {
	default

	# bug #718808
	eapply "${WORKDIR}"/debian/patches/*.patch

	# bug #778461
	sed -i 's/-lmcpp/libmcpp.la/' src/Makefile.am || die

	eautoreconf
}

src_configure() {
	econf \
		--enable-mcpplib \
		--disable-static
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
