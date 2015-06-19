# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/fortune-mod-flashrider/fortune-mod-flashrider-1.10.ebuild,v 1.1 2013/08/02 05:24:31 zzam Exp $

EAPI=5

MY_PN="${PN/-mod/s}"
MY_P="${MY_PN}_${PV}"

DESCRIPTION="Quotes from Prolinux articles and comments"
HOMEPAGE="http://downloads.nanolx.org/index.php?dir=fortunes-flashrider"
SRC_URI="http://downloads.nanolx.org/fortunes-flashrider/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

DEPEND="games-misc/fortune-mod"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare()
{
	sed -e 's#INSTALLDIR = .*#INSTALLDIR = /share/fortune#' -i Makefile
}

src_install() {
	emake install PREFIX="${EPREFIX}"/usr DESTDIR="${D}"
	dodoc AUTHORS ChangeLog README
}
