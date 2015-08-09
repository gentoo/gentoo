# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit eutils toolchain-funcs

DESCRIPTION="An ISO 3166 country code finder"
HOMEPAGE="http://www.grigna.com/diego/linux/countrycodes/"
SRC_URI="http://www.grigna.com/diego/linux/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

S="${WORKDIR}"/${P}/src

src_prepare() {
	epatch "${FILESDIR}"/${PV}-Makefile.patch
	tc-export CC
}

src_install() {
	emake \
		prefix="${D}/usr" \
		mandir="${D}/usr/share/man/man1" install || die "make install failed"
	dosym iso3166 /usr/bin/countrycodes || die
	dosym iso3166.1 /usr/share/man/man1/countrycodes || die
	dodoc ../doc/{Changelog,README} || die
	prepman
}
