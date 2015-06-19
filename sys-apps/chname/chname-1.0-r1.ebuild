# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/chname/chname-1.0-r1.ebuild,v 1.3 2014/08/10 20:23:33 slyfox Exp $

inherit toolchain-funcs

DESCRIPTION="Run a command with a new system hostname"
HOMEPAGE="http://code.google.com/p/chname"
SRC_URI="http://chname.googlecode.com/files/chname-1.0.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND=">=sys-kernel/linux-headers-2.6.16"
RDEPEND=""

src_compile() {
	emake CC=$(tc-getCC) CFLAGS="${CFLAGS} ${LDFLAGS}" chname || die
}

src_install() {
	dobin chname
	doman chname.1
}

pkg_postinst() {
	elog "Note: chname requires a or later kernel with CONFIG_UTS_NS=y."
}
