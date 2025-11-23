# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package

DESCRIPTION="LaTeX package used to create foils and slides"
HOMEPAGE="https://ctan.org/pkg/foiltex"
# Taken from http://www.ctan.org/get/macros/latex/contrib/foiltex.zip
SRC_URI="mirror://gentoo/${P}.zip"
S=${WORKDIR}/${PN}

LICENSE="FoilTeX"
SLOT="0"
KEYWORDS="amd64 ppc x86"

BDEPEND="app-arch/unzip"

src_install() {
	latex-package_src_doinstall all
	dodoc "${S}/README"
}
