# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="${PN}-2003-02-08"
S=${WORKDIR}/${PN}

DESCRIPTION="blinkperl is a telnet server, which plays BlinkenLight movies"
SRC_URI="https://downloads.sourceforge.net/blinkserv/${MY_P}.tar.gz"
HOMEPAGE="http://blinkserv.sourceforge.net/"

SLOT="0"
KEYWORDS="~hppa x86"
LICENSE="GPL-2"
IUSE=""
DEPEND=""
RDEPEND="dev-lang/perl dev-perl/Term-ANSIScreen"

PATCHES=( 	"${FILESDIR}"/${P}-fix-pod2man.patch
			"${FILESDIR}"/${P}-non-local.patch
			"${FILESDIR}"/${P}-Makefile.patch )

src_install() {
	default

	newinitd "${FILESDIR}"/blinkperl.rc blinkperl
	newconfd "${FILESDIR}"/blinkperl.confd blinkperl
}
