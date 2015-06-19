# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/trinity/trinity-1.1.ebuild,v 1.2 2013/03/13 16:32:57 radhermit Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="A Linux system call fuzz tester"
HOMEPAGE="http://codemonkey.org.uk/projects/trinity/"
SRC_URI="http://codemonkey.org.uk/projects/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-kernel/linux-headers"

src_prepare() {
	epatch "${FILESDIR}"/${P}-flags.patch
	tc-export CC
}

src_configure() {
	./configure.sh || die
}

src_install() {
	dobin ${PN}
	dodoc Documentation/* README
}
