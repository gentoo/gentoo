# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

DESCRIPTION="Run a command with a new system hostname"
HOMEPAGE="https://github.com/marineam/chname"
SRC_URI="https://chname.googlecode.com/files/chname-1.0.tar.gz"

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
