# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_6} )

inherit python-single-r1

DESCRIPTION="Tool to produce LaTeX Beamer code from wiki-like input"

HOMEPAGE="http://wiki2beamer.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="|| ( GPL-2 GPL-3 ) FDL-1.3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+examples"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	app-arch/unzip"

src_install() {
	if use examples; then
		# Patch example Makefile
		sed -e 's|../../code/wiki2beamer|wiki2beamer|' \
				-i doc/example/Makefile \
				|| die

		dodoc -r doc/example
	fi

	doman doc/man/${PN}.1
	dodoc ChangeLog README

	python_doscript code/${PN}
}
