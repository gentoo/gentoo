# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd toolchain-funcs

DESCRIPTION="PaX flags maintenance daemon"
HOMEPAGE="https://www.grsecurity.net/"
SRC_URI="https://www.grsecurity.net/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"

src_prepare() {
	# Respect Gentoo flags and don't strip
	sed -i Makefile -e '/^CC=/d' -e '/^CFLAGS?=/d' -e '/^LDFLAGS=/d' -e '/STRIP/d' || die

	default
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	default

	systemd_dounit rpm/${PN}.service
}
