# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit latex-package eutils

S=${WORKDIR}/leaflet

DESCRIPTION="LaTeX package used to create leaflet-type brochures"
SRC_URI="mirror://gentoo/${P}.zip"
HOMEPAGE="http://www.ctan.org/tex-archive/macros/latex/contrib/leaflet/"

LICENSE="LPPL-1.3"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

# checksum from official ftp site changes frequently so we mirror it

TEXMF="/usr/share/texmf-site"

RDEPEND="dev-texlive/texlive-fontsrecommended"
DEPEND="${RDEPEND} app-arch/unzip"
DOCS="README"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-logging.patch"
}
