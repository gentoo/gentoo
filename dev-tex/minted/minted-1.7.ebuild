# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit latex-package

DESCRIPTION="LaTeX package that facilitates expressive syntax highlighting in using the powerful Pygments library"
HOMEPAGE="https://code.google.com/p/minted/"
SRC_URI="https://minted.googlecode.com/files/${PN}-v${PV}.zip"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="
	dev-texlive/texlive-latexextra
	dev-python/pygments"

S="${WORKDIR}"/

src_install() {
	latex-package_src_install
	dodoc README
}
