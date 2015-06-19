# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/trinity/trinity-1.2.ebuild,v 1.1 2013/09/07 20:22:43 radhermit Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="A Linux system call fuzz tester"
HOMEPAGE="http://codemonkey.org.uk/projects/trinity/"
SRC_URI="http://codemonkey.org.uk/projects/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND="sys-kernel/linux-headers"

src_prepare() {
	sed -e 's/^CFLAGS = /CFLAGS +=/' \
		-e 's/-g -O2//' \
		-e 's/-D_FORTIFY_SOURCE=2//' \
		-e '/-o trinity/s/$(CFLAGS)/\0 $(LDFLAGS)/' \
		-e '/^CFLAGS += -Werror/d' \
		-i Makefile || die

	epatch "${FILESDIR}"/${PN}-1.2-videodev2-ioctls.patch
	epatch "${FILESDIR}"/${PN}-1.2-btrfs-headers.patch
	tc-export CC
}

src_configure() {
	./configure.sh || die
}

src_compile() {
	emake V=1
}

src_install() {
	dobin ${PN}
	dodoc Documentation/* README

	if use examples ; then
		exeinto /usr/share/doc/${PF}/scripts
		doexe scripts/*
		docompress -x /usr/share/doc/${PF}/scripts
	fi
}
