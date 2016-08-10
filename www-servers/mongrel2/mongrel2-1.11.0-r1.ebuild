# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="A language agnostic web server focused on web applications"
HOMEPAGE="http://mongrel2.org"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-libs/zeromq
	>=net-libs/mbedtls-2.1[havege]
	dev-db/sqlite:3"
RDEPEND="${DEPEND}"

src_prepare() {
	cp "${FILESDIR}/systemtls.mak" Makefile || die
	eapply "${FILESDIR}/${P}-polarssl-platform-590512.patch"
	eapply_user
}

src_install() {
	emake install PREFIX=/usr DESTDIR="${D}"
	dodoc README examples/configs/mongrel2.conf
}
