# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/aggregate/aggregate-1.6.ebuild,v 1.19 2014/08/10 20:43:10 slyfox Exp $

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
