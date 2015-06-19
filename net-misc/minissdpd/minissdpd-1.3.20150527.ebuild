# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/minissdpd/minissdpd-1.3.20150527.ebuild,v 1.1 2015/05/28 23:04:58 blueness Exp $

EAPI="5"
inherit eutils toolchain-funcs

DESCRIPTION="MiniSSDP Daemon"
SRC_URI="http://miniupnp.free.fr/files/${P}.tar.gz"
HOMEPAGE="http://miniupnp.free.fr/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="|| ( net-misc/miniupnpd net-libs/miniupnpc )"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.2-respect-CC.patch"
	epatch "${FILESDIR}/${PN}-1.2-remove-initd.patch"
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install () {
	einstall PREFIX="${D}"
	newinitd "${FILESDIR}/${PN}.initd-r2" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	dodoc Changelog.txt README
	doman minissdpd.1
}
