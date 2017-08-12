# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="a secure ACME client"
HOMEPAGE="https://kristaps.bsd.lv/acme-client"
SRC_URI="https://kristaps.bsd.lv/acme-client/snapshots/${PN}-portable-${PV}.tgz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-libs/libressl
	dev-libs/libbsd"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}-portable-${PV}

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	DESTDIR="${D}" PREFIX="/usr" MAN1DIR="/usr/share/man/man1" emake install
	dodoc ChangeLog
}
