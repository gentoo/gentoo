# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="A pure Python module for creation and analysis of binary data"
HOMEPAGE="https://github.com/scott-griffiths/bitstring"
SRC_URI="https://github.com/scott-griffiths/${PN}/archive/${P}.tar.gz"
S=${WORKDIR}/${PN}-${P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"

distutils_enable_tests unittest

DOCS=( README.rst release_notes.txt )

src_test() {
	cd test || die
	distutils-r1_src_test
}
