# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package toolchain-funcs

DESCRIPTION="Offers syntax/railroad diagrams"
HOMEPAGE="http://www.ctan.org/tex-archive/support/rail/"
SRC_URI="http://mirror.ctan.org/support/${PN}.zip -> ${P}.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip
	sys-devel/bison
	app-alternatives/lex"

S="${WORKDIR}/${PN}"

src_compile() {
	emake -j1 \
		CC="$(tc-getCC)" \
		CFLAGS="-DYYDEBUG ${CFLAGS} ${LDFLAGS}" \
		rail rail.dvi
}

src_install() {
	local LATEX_PACKAGE_SKIP="try.tex"

	latex-package_src_doinstall sty doc
	dobin rail
	newman rail.man rail.1
}
