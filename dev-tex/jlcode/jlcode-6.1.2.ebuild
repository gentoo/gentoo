# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit latex-package

DESCRIPTION="LaTeX package, language definition for Julia source code syntax highlighting"
HOMEPAGE="https://github.com/wg030/jlcode"

MY_COMMIT=0a26d044e1fee13c86fb1661996c602ff450e167

SRC_URI="https://github.com/wg030/jlcode/archive/${MY_COMMIT}.tar.gz -> ${P}.tgz"
S="${WORKDIR}"/${PN}-${MY_COMMIT}

SLOT="0"
LICENSE="LPPL-1.3"
KEYWORDS="~amd64"

RDEPEND="
	dev-texlive/texlive-latexextra
"
