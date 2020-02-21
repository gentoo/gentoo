# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="The advanced PC speaker beeper"
HOMEPAGE="http://www.johnath.com/beep"
SRC_URI="http://www.johnath.com/beep/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ppc ppc64 sparc x86"
IUSE="suid"

PATCHES=(
	"${FILESDIR}/${P}-Makefile.patch"
	"${FILESDIR}/${P}-CVE-2018-0492.patch"
)

pkg_setup() {
	tc-export CC
}

src_install() {
	dobin beep
	if use suid; then
		fowners :audio /usr/bin/beep
		fperms 4710 /usr/bin/beep
	else
		fperms 0711 /usr/bin/beep
	fi
	unpack "./${PN}.1.gz"
	doman "${PN}.1"
	einstalldocs
}
