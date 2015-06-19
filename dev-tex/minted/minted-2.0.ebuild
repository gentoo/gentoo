# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/minted/minted-2.0.ebuild,v 1.1 2015/03/23 15:10:46 jlec Exp $

EAPI=5

inherit latex-package

DESCRIPTION="LaTeX package that facilitates expressive syntax highlighting in using the powerful Pygments library"
HOMEPAGE="https://github.com/gpoore/minted"
SRC_URI="https://github.com/gpoore/minted/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="
	dev-texlive/texlive-latexextra
	dev-python/pygments"

S="${WORKDIR}"/${P}/source

src_install() {
	latex-package_src_install
	dodoc "${S}"/../*md
}
