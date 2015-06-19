# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/biblatex-apa/biblatex-apa-6.6.ebuild,v 1.2 2015/02/08 20:40:23 mrueg Exp $

EAPI=5

inherit latex-package

DESCRIPTION="APA style for BibLaTeX"
HOMEPAGE="http://www.ctan.org/pkg/biblatex-apa https://github.com/plk/biblatex-apa"
SRC_URI="https://github.com/plk/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LPPL-1.3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

RDEPEND="dev-texlive/texlive-bibtexextra
	dev-tex/biblatex"
DEPEND="${RDEPEND}"

TEXMF=/usr/share/texmf-site

src_install() {
	insinto "${TEXMF}"
	doins -r tex

	dodoc README RELEASE
	use doc && { pushd doc/ ; latex-package_src_doinstall doc ; popd ; }
}
