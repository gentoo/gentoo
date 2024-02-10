# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="High quality system independent, open source libm"
HOMEPAGE="https://github.com/JuliaLang/openlibm"
SRC_URI="https://github.com/JuliaMath/openlibm/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain MIT ISC BSD-2 LGPL-2.1+"
# See https://abi-laboratory.pro/index.php?view=timeline&l=openlibm
SLOT="0/3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

src_prepare() {
	default
	sed -e "/^OLM_LIBS :=/s/^/#/" \
		-e "/install: /s/install-static//" \
	-i Makefile || die
}

src_configure() {
	tc-export CC CXX FC AR LD
	default
}

src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" \
		libdir="${EPREFIX}/usr/$(get_libdir)" install
	dodoc README.md
}
