# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package

S="${WORKDIR}"/${PN}

# checksum from official ftp site changes frequently so we mirror it
DESCRIPTION="LaTeX styles for formless letters in German or English"
SRC_URI="mirror://gentoo/${P}.zip"
HOMEPAGE="http://www.ctan.org/tex-archive/macros/latex/contrib/g-brief/"
LICENSE="LPPL-1.2"

IUSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

RDEPEND="dev-texlive/texlive-langgerman"
DEPEND="${RDEPEND}
	app-arch/unzip"

TEXMF="/usr/share/texmf-site"

src_compile() {
	# latex chokes if these file exist, bug #573374
	rm -f g-brief.drv g-brief.cls g-brief.sty g-brief2.cls g-brief2.sty beispiel.tex beispiel2.tex || die
	latex-package_src_compile
	# Now that the source is processed, remove it so that it is not (wrongly)
	# reprocessed at src_install.
	rm -f g-brief.dtx || die
}
