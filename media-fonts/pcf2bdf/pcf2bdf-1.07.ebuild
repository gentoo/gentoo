# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Converts PCF fonts to BDF fonts"
HOMEPAGE="https://github.com/ganaware/pcf2bdf/"
SRC_URI="https://github.com/ganaware/pcf2bdf/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~loong ~ppc ~s390 ~sparc ~x86"

src_compile() {
	emake -f Makefile.gcc CC="$(tc-getCXX)" CFLAGS="${CXXFLAGS}"
}

src_install() {
	emake -f Makefile.gcc \
		PREFIX="${ED}/usr" \
		MANPATH="${ED}/usr/share/man/man1" \
		install
}
