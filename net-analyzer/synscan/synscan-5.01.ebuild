# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/synscan/synscan-5.01.ebuild,v 1.2 2014/07/18 17:16:07 ssuominen Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="A fast asynchronous half-open TCP portscanner"
HOMEPAGE="http://www.digit-labs.org/files/tools/synscan/"
SRC_URI="http://www.digit-labs.org/files/tools/${PN}/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="kernel_FreeBSD kernel_linux"

RDEPEND="net-libs/libpcap"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
	eautoconf
}

src_compile() {
	local _target
	use kernel_FreeBSD && _target=freebsd
	use kernel_linux && _target=linux

	emake ${_target}
}

src_install() {
	dobin synscan sslog
	dodoc AUTHORS README
}
