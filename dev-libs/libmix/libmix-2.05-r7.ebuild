# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="Programs Crypto/Network/Multipurpose Library"
HOMEPAGE="http://mixter.void.ru/"
SRC_URI="http://mixter.void.ru/${P/.}.tgz"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux"
IUSE="static-libs"

PATCHES=(
	"${FILESDIR}"/${P}-fix-pattern.patch
	"${FILESDIR}"/${P}-gentoo-r1.patch
	"${FILESDIR}"/${P}-libnet.patch
)

src_prepare() {
	default

	mv configure.{in,ac} || die

	sed -i \
		-e 's/expf/libmix_expf/g' \
		-e 's/logf/libmix_logf/g' \
		aes/saferp.c || die

	eautoreconf
}

src_configure() {
	tc-export CC CXX

	econf \
		$(use_enable static-libs static) \
		--without-net2
}
