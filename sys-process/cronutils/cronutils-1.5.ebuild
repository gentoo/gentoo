# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/cronutils/cronutils-1.5.ebuild,v 1.3 2014/03/04 19:57:43 ago Exp $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="Utilities to assist running batch processing jobs"
HOMEPAGE="http://code.google.com/p/cronutils/"
SRC_URI="http://cronutils.googlecode.com/files/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="-D_XOPEN_SOURCE=500 ${CFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" prefix=/usr install
}
