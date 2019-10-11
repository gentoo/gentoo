# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit eutils portability toolchain-funcs

MY_P=eject-${PV}

DESCRIPTION="eject command for FreeBSD systems"
HOMEPAGE="http://www.freshports.org/sysutils/eject/"
SRC_URI="ftp://ports.jp.FreeBSD.org/pub/FreeBSD-jp/OD/${MY_P}.tar.gz
	ftp://ftp4.jp.FreeBSD.org/pub/FreeBSD-jp/OD/${MY_P}.tar.gz
	ftp://ftp.ics.es.osaka-u.ac.jp/pub/mirrors/FreeBSD-jp/OD/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-manpage.patch
	epatch "${FILESDIR}"/${P}-devname.patch
}

src_compile() {
	$(get_bmake) CC="$(tc-getCC)" PREFIX=/usr eject || die
}

src_install() {
	dobin "${S}"/eject || die
	doman "${S}"/eject.1
	dodoc "${S}"/README
}
