# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package

DESCRIPTION="Easy driver-independent access to colors"
HOMEPAGE="http://www.ukern.de/tex/xcolor.html"
SRC_URI="http://www.ukern.de/tex/xcolor/ctan/${P//[.-]/}.zip"

LICENSE="LPPL-1.2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc"

RDEPEND="dev-texlive/texlive-latex"

DEPEND="${RDEPEND}
	doc? (
		dev-texlive/texlive-pstricks
		dev-texlive/texlive-latexextra
	)"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}"

TEXMF="/usr/share/texmf-site"

src_prepare() {
	if has_version '>=dev-texlive/texlive-latexrecommended-2019'; then
		#sty filename has been changed in tl2019
		sed -i -e s#fvrb-ex#fancyvrb-ex# xcolor.dtx || die
	fi
	default
}

src_install() {
	export VARTEXFONTS="${T}/fonts"

	latex-package_src_install

	dodoc README ChangeLog
}
