# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="FreeBSD command-line tool that reminds you when its time to leave"
HOMEPAGE="http://www.freebsd.org/cgi/cvsweb.cgi/src/usr.bin/leave/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-posix.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	dobin leave
	doman leave.1
	dodoc "${FILESDIR}"/README
}
