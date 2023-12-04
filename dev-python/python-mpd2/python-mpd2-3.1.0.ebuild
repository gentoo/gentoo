# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
# py3.12: https://github.com/Mic92/python-mpd2/issues/214
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1

DESCRIPTION="Python MPD client library"
HOMEPAGE="
	https://github.com/Mic92/python-mpd2/
	https://pypi.org/project/python-mpd2/
"
# as of 3.1.0, sdist is missing some doc files
SRC_URI="
	https://github.com/Mic92/python-mpd2/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="LGPL-3+"
KEYWORDS="amd64 arm64 ppc ppc64 x86"
SLOT="0"
IUSE="examples +twisted"

RDEPEND="
	twisted? ( dev-python/twisted[${PYTHON_USEDEP}] )
"
BDEPEND="
	test? (
		dev-python/twisted[${PYTHON_USEDEP}]
	)
"

DOCS=( README.rst doc/{changes.rst,commands_header.txt} doc/topics/. )

distutils_enable_sphinx doc --no-autodoc
distutils_enable_tests pytest

python_test() {
	epytest mpd/tests.py
}

python_install_all() {
	distutils-r1_python_install_all

	use examples && dodoc -r examples/.
}
