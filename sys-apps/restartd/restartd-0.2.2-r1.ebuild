# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PV=${PV/_alpha/.a-}
DESCRIPTION="A daemon for checking your running and not running processes"
HOMEPAGE="https://packages.debian.org/unstable/utils/restartd"
SRC_URI="mirror://debian/pool/main/r/restartd/${PN}_${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

src_prepare() {
	default
	sed -i Makefile -e 's|-o restartd|$(LDFLAGS) &|g' || die "sed Makefile"
}

src_compile() {
	emake CC="$(tc-getCC)" C_ARGS="${CFLAGS}"
}

src_install() {
	dodir /etc /usr/sbin /usr/share/man/man8 /usr/share/man/fr/man8/
	default
}
