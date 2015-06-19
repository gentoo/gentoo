# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ser2net/ser2net-2.7-r1.ebuild,v 1.3 2012/09/23 08:21:37 phajdan.jr Exp $

EAPI=4

inherit base autotools

DESCRIPTION="Serial To Network Proxy"
SRC_URI="mirror://sourceforge/ser2net/${P}.tar.gz"
HOMEPAGE="http://sourceforge.net/projects/ser2net"

KEYWORDS="~amd64 ppc x86"
SLOT="0"
LICENSE="GPL-2"

DEPEND="tcpd? ( sys-apps/tcp-wrappers )"
RDEPEND="${DEPEND}"

IUSE="tcpd"

PATCHES=( "${FILESDIR}/${P}-b230400.diff" )
DOCS=( "AUTHORS" "NEWS" "README" "ChangeLog" )

src_prepare() {
	base_src_prepare
	eautoreconf
}

src_configure() {
	local myopts="$(use_with tcpd tcp-wrappers) --with-uucp-locking"
	econf ${myopts} || die "econf failed"
}

src_install () {
	base_src_install
	insinto /etc
	newins ${PN}.conf ${PN}.conf.dist
	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}
}
