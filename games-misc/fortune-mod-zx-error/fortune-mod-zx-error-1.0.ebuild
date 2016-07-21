# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=5
MY_P="fortunes-zx-error-${PV}"
DESCRIPTION="Sinclair ZX Spectrum BASIC error Fortunes"
HOMEPAGE="http://korpus.juls.savba.sk/~garabik/software/fortunes-zx-error.html"
SRC_URI="http://korpus.juls.savba.sk/~garabik/software/fortunes-zx-error/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="games-misc/fortune-mod"

S=${WORKDIR}/${MY_P}

src_install() {
	insinto /usr/share/fortune
	newins zx/error zx-error
	newins zx/error.dat zx-error.dat
	dodoc README
}
