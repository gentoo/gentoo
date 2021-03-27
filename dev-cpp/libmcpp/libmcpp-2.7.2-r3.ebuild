# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_P=${P/lib/}

DESCRIPTION="A portable C++ preprocessor"
HOMEPAGE="http://mcpp.sourceforge.net"
SRC_URI="mirror://sourceforge/mcpp/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 x86 ~x86-linux ~x64-macos"
IUSE="static-libs"

PATCHES=(
	"${FILESDIR}"/${PN}-2.7.2-fix-build-system.patch
	"${FILESDIR}"/${PN}-2.7.2-zeroc.patch
	"${FILESDIR}"/${PN}-2.7.2-gniibe.patch
)

src_prepare() {
	default

	# bug #778461
	sed -i 's/-lmcpp/libmcpp.la/' src/Makefile.am || die

	eautoreconf
}

src_configure() {
	econf \
		--enable-mcpplib \
		$(use_enable static-libs static)
}

src_install() {
	default

	if ! use static-libs; then
		find "${D}" -name '*.la' -delete || die
	fi
}
