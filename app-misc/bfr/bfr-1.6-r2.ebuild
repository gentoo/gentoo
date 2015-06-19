# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/bfr/bfr-1.6-r2.ebuild,v 1.6 2014/12/04 08:38:38 ago Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="General-purpose command-line pipe buffer"
HOMEPAGE="http://www.glines.org/software/bfr"
SRC_URI="http://www.glines.org/bin/pk/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 sparc x86"

DEPEND="dev-lang/perl"

src_prepare() {
	epatch "${FILESDIR}"/${P}-perl.patch
	tc-export CC
}
