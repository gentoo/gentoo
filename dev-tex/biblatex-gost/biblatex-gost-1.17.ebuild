# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package

DESCRIPTION="Biblatex styles for Russian GOST 7.0.5-2008 bibliography standard"
HOMEPAGE="https://github.com/odomanov/biblatex-gost"
SRC_URI="https://github.com/odomanov/${PN}/archive/ver.${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LPPL-1.3c"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-texlive/texlive-latexextra
	>=dev-tex/biblatex-3.8
	>=dev-tex/biber-2.8"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-ver.${PV}"

src_install() {
	insinto "${TEXMF}"
	doins -r tex
}
