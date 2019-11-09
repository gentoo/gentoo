# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package

DESCRIPTION="A LaTeX module to access SVN version info"
HOMEPAGE="https://www.brucker.ch/projects/svninfo/index.en.html"
SRC_URI="https://www.brucker.ch/projects/svninfo/download/${P}.tar.gz"

KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

LICENSE="LPPL-1.2"
SLOT="0"
IUSE=""

DOCS=( "README" )

PATCHES=( "${FILESDIR}/${PN}-0.5-latex-compile.patch" )

TEXMF=/usr/share/texmf-site

src_compile() {
	export VARTEXFONTS="${T}/fonts"
	emake -j1
}
