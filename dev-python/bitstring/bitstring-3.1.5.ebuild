# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} )
inherit distutils-r1

DESCRIPTION="A pure Python module for creation and analysis of binary data"
HOMEPAGE="https://github.com/scott-griffiths/bitstring"
SRC_URI="https://github.com/scott-griffiths/${PN}/archive/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${PN}-${P}

DOCS=( README.rst release_notes.txt )

python_test() {
	pushd test >/dev/null || die
	"${PYTHON}" -m unittest discover || die "Testing failed with ${EPYTHON}"
	popd >/dev/null || die
}
