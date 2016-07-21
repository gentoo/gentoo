# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils linux-info toolchain-funcs

DESCRIPTION="A program for announcing VLANs using GVRP"
HOMEPAGE="http://sokrates.mimuw.edu.pl/~sebek/gvrpcd/"
SRC_URI="http://sokrates.mimuw.edu.pl/~sebek/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-libs/libnet:1.1"
RDEPEND="${DEPEND}"

CONFIG_CHECK="~VLAN_8021Q ~VLAN_8021Q_GVRP"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-respect-ldflags.patch
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dosbin gvrpcd
	dodoc README
	newinitd "${FILESDIR}"/init.gvrpcd gvrpcd
	newconfd "${FILESDIR}"/conf.gvrpcd gvrpcd
}
