# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/scanlogd/scanlogd-2.2.7.ebuild,v 1.3 2015/03/02 09:22:12 ago Exp $

EAPI=5
inherit eutils savedconfig toolchain-funcs user

DESCRIPTION="a port scan detection tool"
SRC_URI="http://www.openwall.com/scanlogd/${P}.tar.gz"
HOMEPAGE="http://www.openwall.com/scanlogd/"

LICENSE="scanlogd GPL-2" # GPL-2 for initscript
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE="+nids pcap"
REQUIRED_USE="?? ( nids pcap )"

DEPEND="
	nids? ( net-libs/libnids )
	pcap? ( net-libs/libpcap )
"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	restore_config params.h
	tc-export CC
}

src_compile() {
	local target=linux
	use nids && target=libnids
	use pcap && target=libpcap
	emake ${target}
}

src_install() {
	dosbin scanlogd
	doman scanlogd.8
	newinitd "${FILESDIR}"/scanlogd.rc scanlogd
	save_config params.h
}

pkg_preinst() {
	enewgroup scanlogd
	enewuser scanlogd -1 -1 /dev/null scanlogd
}
