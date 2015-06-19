# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/hd2u/hd2u-1.0.3.ebuild,v 1.7 2012/02/01 09:10:53 ssuominen Exp $

EAPI=4

inherit eutils

DESCRIPTION="Dos2Unix like text file converter"
HOMEPAGE="http://www.megaloman.com/~hany/software/hd2u/"
SRC_URI="http://www.megaloman.com/~hany/_data/hd2u/${P}.tgz"

KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="
	dev-libs/popt"
RDEPEND="${DEPEND}
	!app-text/dos2unix"

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
}
