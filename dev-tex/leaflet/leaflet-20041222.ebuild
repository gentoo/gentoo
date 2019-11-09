# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package

DESCRIPTION="LaTeX package used to create leaflet-type brochures"
HOMEPAGE="https://www.ctan.org/tex-archive/macros/latex/contrib/leaflet/"
SRC_URI="mirror://gentoo/${P}.zip"
# checksum from official ftp site changes frequently so we mirror it

KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

LICENSE="LPPL-1.3"
SLOT="0"
IUSE=""

RDEPEND="dev-texlive/texlive-fontsrecommended"
DEPEND="${RDEPEND}
	app-arch/unzip
"

DOCS=( "README" )
PATCHES=( "${FILESDIR}/${P}-logging.patch" )

TEXMF="/usr/share/texmf-site"

S=${WORKDIR}/leaflet
