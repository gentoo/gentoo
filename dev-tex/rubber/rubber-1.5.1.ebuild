# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7} )

inherit distutils-r1

DESCRIPTION="A LaTeX wrapper for automatically building documents"
HOMEPAGE="https://launchpad.net/rubber/"
SRC_URI="https://launchpad.net/rubber/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2 GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="virtual/latex-base"
DEPEND="${RDEPEND}
	virtual/texi2dvi"

python_install() {
	local my_install_args=(
		--mandir="${EPREFIX}/usr/share/man"
		--infodir="${EPREFIX}/usr/share/info"
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
	)

	distutils-r1_python_install "${my_install_args[@]}"
}
