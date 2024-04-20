# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Small utility for Linux/SPARC that list devices on SBUS"
HOMEPAGE="https://people.redhat.com/tcallawa/lssbus/"
SRC_URI="https://people.redhat.com/tcallawa/lssbus/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* sparc"

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dosbin lssbus
	einstalldocs
}
