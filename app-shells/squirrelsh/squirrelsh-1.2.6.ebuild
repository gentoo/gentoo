# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils multilib toolchain-funcs

DESCRIPTION="An advanced, cross-platform object oriented scripting shell based
on the squirrel scripting language"
HOMEPAGE="http://squirrelsh.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="doc"

RDEPEND="dev-libs/libpcre"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-rename-LDFLAGS.patch
	epatch "${FILESDIR}"/${PN}-no-strip.patch
	epatch "${FILESDIR}"/${PN}-fix-in_LDFLAGS.patch
	epatch "${FILESDIR}"/${PN}-remove-forced-abi.patch
	epatch "${FILESDIR}"/${PN}-no-docs.patch
}

src_configure() {
	#This package uses a custom written configure script
	./configure --prefix="${D}"/usr \
		--with-cc="$(tc-getCC)" \
		--with-cpp="$(tc-getCXX)" \
		--with-linker="$(tc-getCXX)" \
		--libdir=/usr/"$(get_libdir)" \
		--with-pcre="system" \
		--with-squirrel="local" \
		--with-mime=no || die "configure failed"
}

src_install() {
	emake DESTDIR="${D}" install
	doman doc/${PN}.1
	dodoc HISTORY INSTALL README
	use doc && dodoc doc/*.pdf
}
