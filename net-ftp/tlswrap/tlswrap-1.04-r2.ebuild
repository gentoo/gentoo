# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils

DESCRIPTION="a TLS/SSL FTP wrapper/proxy which allows to use TLS with every FTP client"
HOMEPAGE="http://www.tlswrap.com"
SRC_URI="http://www.tlswrap.com/${P}.tar.gz"

# GPL-2 for Gentoo init script
LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl"

DEPEND="!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:= )"
RDEPEND=${DEPEND}

PATCHES=(
	"${FILESDIR}/${P}-libressl.patch"
)

src_install() {
	emake prefix="${D}/usr" install
	dodoc ChangeLog README
	newinitd "${FILESDIR}/tlswrap.init" tlswrap
}
