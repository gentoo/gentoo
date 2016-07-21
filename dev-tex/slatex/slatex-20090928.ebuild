# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

# for updating the texmf database, id est latex-package_rehash
inherit latex-package

DESCRIPTION="SLaTeX is a Scheme program that allows you to write Scheme code in your (La)TeX source"
HOMEPAGE="http://www.ccs.neu.edu/home/dorai/slatex/slatxdoc.html"
SRC_URI="http://evalwhen.com/slatex/slatex.tar.bz2 -> ${P}.tar.bz2"

LICENSE="freedist" # license doesn't grant the right for modifications
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="dev-scheme/guile"
DEPEND="${CDEPEND} dev-scheme/scmxlate !dev-scheme/plt-scheme"
RDEPEND="${CDEPEND}"

S="${WORKDIR}/${PN}"

TARGET_DIR="/usr/share/${PN}"

src_prepare() {
	sed "s:\"/home/dorai/.www/slatex/slatex.scm\":\"${TARGET_DIR}/slatex.scm\":" \
		-i scmxlate-slatex-src.scm || die "sed failed"
}

src_compile() {
	local command="(load \"/usr/share/scmxlate/scmxlate.scm\")"
	guile -c "${command}" <<< "guile" || die
}

src_install() {
	insinto "${TARGET_DIR}"
	doins ${PN}.scm || die "doins failed"
	insinto /usr/share/texmf/tex/latex/slatex/
	doins ${PN}.sty || die "doins failed"
	dobin ${PN} || die "dobin failed"
}
