# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/tipcutils/tipcutils-2.0.0.ebuild,v 1.3 2012/12/08 22:21:54 ulm Exp $

EAPI=4
inherit eutils toolchain-funcs # linux-info

DESCRIPTION="Utilities for TIPC (Transparent Inter-Process Communication)"
HOMEPAGE="http://tipc.sourceforge.net"
SRC_URI="mirror://sourceforge/tipc/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND=">=sys-kernel/linux-headers-2.6.39"

S=${WORKDIR}/${P}/tipc-config

src_prepare() {
	epatch "${FILESDIR}"/${P}-rename_configuration_message_field.patch
	sed -i -e '/OFLAGS/s:-O2::' Makefile || die
}

src_compile() {
	tc-export CC
	# inherit linux-info and add IFLAGS="${KERNEL_DIR}/include" below in order
	# to build against headers in /usr/src/linux
	emake EXTRAS="${CFLAGS}"
}

src_install() {
	dosbin tipc-config
}
