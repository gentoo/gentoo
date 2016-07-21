# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="md4 and edonkey hash algorithm tool"
HOMEPAGE="http://linux.xulin.de/c/"
SRC_URI="http://linux.xulin.de/c/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}/md4sum-fix-out-of-bounds-write.diff"
}

src_compile() {
	sed -i -e "s:CFLAGS=:CFLAGS=${CFLAGS} :g" \
		-e "s:install -s:install:g" Makefile
	emake LDFLAGS="${LDFLAGS}" CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	mkdir -p "${D}/usr/bin"
	mkdir -p "${D}/usr/share/man/man1"
	einstall || die "einstall failed"
}
