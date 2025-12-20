# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Safely remove spaces and strange characters from filenames"
HOMEPAGE="https://github.com/dharple/detox"
SRC_URI="https://github.com/dharple/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~hppa ~mips ~ppc ~riscv ~x86"

BDEPEND="
	app-alternatives/yacc
	app-alternatives/lex
"

src_prepare() {
	default
	eautoreconf
}
