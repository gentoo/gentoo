# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/argp-standalone/argp-standalone-1.3.ebuild,v 1.3 2012/10/18 10:43:44 blueness Exp $

EAPI="4"

inherit eutils

DESCRIPTION="Standalone argp library for use with uclibc"
HOMEPAGE="http://www.lysator.liu.se/~nisse/misc/"
SRC_URI="http://www.lysator.liu.se/~nisse/misc/argp-standalone-1.3.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~mips ~ppc x86"
IUSE=""

DEPEND="!sys-libs/glibc"

src_prepare() {
	epatch "${FILESDIR}/${P}-throw-in-funcdef.patch"
}

src_install() {
	dolib.a libargp.a

	insinto /usr/include
	doins argp.h
}
