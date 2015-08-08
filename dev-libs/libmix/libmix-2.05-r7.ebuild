# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools base multilib toolchain-funcs

DESCRIPTION="Programs Crypto/Network/Multipurpose Library"
HOMEPAGE="http://mixter.void.ru/"
SRC_URI="http://mixter.void.ru/${P/.}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="static-libs"

S=${WORKDIR}/${PN}-v${PV}

PATCHES=(
	"${FILESDIR}"/${P}-fix-pattern.patch
	"${FILESDIR}"/${P}-gentoo-r1.patch
	"${FILESDIR}"/${P}-libnet.patch
)

DOCS=( CHANGES )

src_prepare() {
	base_src_prepare

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
