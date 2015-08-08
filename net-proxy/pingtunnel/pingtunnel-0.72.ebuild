# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Tunnel TCP over ICMP"
HOMEPAGE="http://www.cs.uit.no/~daniels/PingTunnel"
SRC_URI="http://www.cs.uit.no/~daniels/PingTunnel/PingTunnel-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~sh ~x86"
IUSE="doc selinux"

DEPEND="
	net-libs/libpcap
	selinux? ( sys-libs/libselinux )
"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/PingTunnel

src_prepare(){
	epatch "${FILESDIR}"/${P}_makefile.patch
}

src_compile() {
	tc-export CC
	emake $(usex selinux "SELINUX=1" "SELINUX=0")
}

src_install() {
	default
	use doc && dohtml web/*
}
