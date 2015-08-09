# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils toolchain-funcs

DESCRIPTION="Take a list of prefixes and perform two optimisations to reduce the length of the prefix list"
HOMEPAGE="http://dist.automagic.org/"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc sparc x86"
IUSE=""

RDEPEND="dev-lang/perl"
DEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-build-fixup.patch
}

src_configure() {
	tc-export CC
	econf
}

src_install() {
	dobin aggregate aggregate-ios || die
	doman aggregate{,-ios}.1
	dodoc HISTORY
}
