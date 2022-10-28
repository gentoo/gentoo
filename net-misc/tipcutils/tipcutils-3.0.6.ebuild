# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Utilities for TIPC (Transparent Inter-Process Communication)"
HOMEPAGE="http://tipc.sourceforge.net"
SRC_URI="mirror://sourceforge/tipc/${P/-/_}.tgz"
S="${WORKDIR}"/${PN}

LICENSE="|| ( BSD-2 GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/libdaemon:=
	net-libs/libmnl:=
"
DEPEND="
	${RDEPEND}
	>=sys-kernel/linux-headers-2.6.39
"

src_configure() {
	CONFIG_SHELL="${BROOT}"/bin/bash econf
}

src_compile() {
	emake clean
	emake
}
