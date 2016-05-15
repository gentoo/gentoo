# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit latex-package eutils

DESCRIPTION="LaTeX package for source code syntax highlighting"
HOMEPAGE="https://github.com/gpoore/minted"
SRC_URI="https://github.com/gpoore/minted/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

DEPEND="app-arch/unzip"
RDEPEND="
	dev-texlive/texlive-latexextra
	dev-python/pygments"

S="${WORKDIR}"/${P}/source

src_prepare() {
	epatch "${FILESDIR}/minted-2.1-remove-extra-curly-brace.patch"
}

src_install() {
	LATEX_DOC_ARGUMENTS='-shell-escape'
	latex-package_src_install
	dodoc "${S}"/../*md
}
