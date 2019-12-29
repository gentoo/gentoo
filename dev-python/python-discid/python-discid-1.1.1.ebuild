# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1

DESCRIPTION="Python bindings for libdiscid"
HOMEPAGE="https://github.com/JonnyJD/python-discid"
SRC_URI="https://github.com/JonnyJD/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="doc"

RDEPEND=">=media-libs/libdiscid-0.2.2"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

python_compile_all() {
	if use doc; then
		cd doc || die
		sphinx-build . _build/html || die
		HTML_DOCS=( doc/_build/html/. )
	fi
}

python_test() {
	esetup.py test
}
