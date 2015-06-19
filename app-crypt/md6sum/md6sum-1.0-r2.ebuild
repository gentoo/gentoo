# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/md6sum/md6sum-1.0-r2.ebuild,v 1.3 2015/01/26 09:43:34 ago Exp $

EAPI="5"

inherit eutils

DESCRIPTION="A C implementation of MD6"
HOMEPAGE="http://groups.csail.mit.edu/cis/md6"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}/${P}-ldflags.patch"
	epatch "${FILESDIR}/${P}-cflags.patch"
	epatch "${FILESDIR}/${P}-format-security.patch"
}

src_install() {
	default
	newdoc README_Reference.txt README
}
