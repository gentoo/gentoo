# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Small utility for Linux/SPARC that list devices on SBUS"
HOMEPAGE="https://people.redhat.com/tcallawa/lssbus/"
SRC_URI="https://people.redhat.com/tcallawa/lssbus/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~sparc"

src_compile() {
	append-cflags -std=gnu89 # Bug #951330

	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dosbin lssbus
	einstalldocs
}
