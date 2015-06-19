# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/siphon/siphon-666-r1.ebuild,v 1.6 2014/07/17 01:09:22 jer Exp $

EAPI=5
inherit eutils toolchain-funcs

MY_P=${PN}-v.${PV}

DESCRIPTION="A portable passive network mapping suite"
HOMEPAGE="http://siphon.datanerds.net/"
SRC_URI="${HOMEPAGE}${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

DEPEND="net-libs/libpcap"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	epatch "${FILESDIR}"/${P}-log.patch
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin ${PN}
	insinto /etc
	doins osprints.conf
	dodoc README
}
