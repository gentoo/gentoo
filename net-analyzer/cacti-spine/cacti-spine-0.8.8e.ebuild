# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/cacti-spine/cacti-spine-0.8.8e.ebuild,v 1.5 2015/07/23 09:34:27 ago Exp $

EAPI=5
inherit autotools eutils

MY_P=${PN}-${PV/_p/-}

DESCRIPTION="Spine is a fast poller for Cacti (formerly known as Cactid)"
HOMEPAGE="http://cacti.net/spine_info.php"
SRC_URI="http://www.cacti.net/downloads/spine/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 hppa ~ppc ~ppc64 sparc x86"

DEPEND="
	dev-libs/openssl:*
	net-analyzer/net-snmp
	virtual/mysql
"
RDEPEND="
	${DEPEND}
	>net-analyzer/cacti-0.8.8
"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-0.8.8e-fix-ac-macro.patch \
		"${FILESDIR}"/${PN}-0.8.8e-net-snmp.patch \
		"${FILESDIR}"/${PN}-0.8.8d-mysql.patch \
		"${FILESDIR}"/${PN}-0.8.8d-ping.patch \
		"${FILESDIR}"/${PN}-0.8.8d-snmp_spine_close.patch

	sed -i -e 's/^bin_PROGRAMS/sbin_PROGRAMS/' Makefile.am
	AT_M4DIR="config" eautoreconf
}

src_install() {
	dosbin spine
	insinto /etc/
	insopts -m0640 -o root
	newins spine.conf{.dist,}
	dodoc ChangeLog README
}
