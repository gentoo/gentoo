# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# for updating the texmf database, id est latex-package_rehash
inherit latex-package

DESCRIPTION="A Scheme program allowing you to write Scheme in your (La)TeX source"
HOMEPAGE="http://www.ccs.neu.edu/home/dorai/slatex/slatxdoc.html"
SRC_URI="http://www.ccs.neu.edu/home/dorai/slatex/${PN}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-scheme/guile"
DEPEND="${RDEPEND}
	dev-scheme/scmxlate"

S="${WORKDIR}/${PN}"

TARGET_DIR="/usr/share/${PN}"

src_prepare() {
	default
	sed "s:\"/home/dorai/.www/slatex/slatex.scm\":\"${TARGET_DIR}/slatex.scm\":" \
		-i scmxlate-slatex-src.scm || die "sed failed"
}

src_compile() {
	local command="(load \"/usr/share/scmxlate/scmxlate.scm\")"
	guile -c "${command}" <<< "guile" || die
}

src_install() {
	insinto "${TARGET_DIR}"
	doins slatex.scm
	insinto "${TEXMF}/tex/latex/${PN}"
	doins slatex.sty
	dobin slatex
}
