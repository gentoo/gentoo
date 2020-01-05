# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="Python package to parse, read and write Microsoft OLE2 files"
HOMEPAGE="https://www.decalage.info/olefile"
SRC_URI="https://github.com/decalage2/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND=""
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

python_compile_all() {
	if use doc; then
	   emake -C doc html
	   HTML_DOCS=( doc/_build/html/. )
	fi

}
