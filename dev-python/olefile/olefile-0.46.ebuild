# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{5,6,7}} pypy{,3} )

inherit distutils-r1

DESCRIPTION="Python package to parse, read and write Microsoft OLE2 files"
HOMEPAGE="https://www.decalage.info/olefile"
SRC_URI="https://github.com/decalage2/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ~hppa ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND=""
BDEPEND="
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

python_compile_all() {
	if use doc; then
	   emake -C doc html
	   HTML_DOCS=( doc/_build/html/. )
	fi

}
