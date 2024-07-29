# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Scans the shares of a SMB/NetBIOS network"
HOMEPAGE="http://nmbscan.g76r.eu/"
SRC_URI="http://nmbscan.g76r.eu/down/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~ppc ppc64 ~sparc x86"

RDEPEND="net-dns/bind-tools
	net-fs/samba
	net-misc/iputils
	sys-apps/net-tools
	app-alternatives/awk"

S=${WORKDIR}
PATCHES=( "${FILESDIR}"/${P}-head.diff )

src_compile() { :; }

src_install() {
	dobin nmbscan
}
