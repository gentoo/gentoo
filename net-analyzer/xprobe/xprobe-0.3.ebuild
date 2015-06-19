# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/xprobe/xprobe-0.3.ebuild,v 1.7 2014/07/18 12:12:20 jer Exp $

EAPI=5
inherit eutils

MY_P=${PN}2-${PV}

DESCRIPTION="Active OS fingerprinting tool - this is Xprobe2"
HOMEPAGE="http://sys-security.com/blog/xprobe2"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"

DEPEND="net-libs/libpcap"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc43.patch
	sed -i -e 's:strip:true:' src/Makefile.in || die
}

src_install() {
	default
	dodoc AUTHORS CHANGELOG CREDITS README TODO docs/*.{txt,pdf}
}
