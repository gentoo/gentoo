# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/trinity/trinity-1.4.ebuild,v 1.1 2014/06/25 04:57:32 radhermit Exp $

EAPI=5

inherit toolchain-funcs eutils

DESCRIPTION="A Linux system call fuzz tester"
HOMEPAGE="http://codemonkey.org.uk/projects/trinity/"
SRC_URI="http://codemonkey.org.uk/projects/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND="
	app-arch/xz-utils
	sys-kernel/linux-headers
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-flags.patch
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
