# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Manipulation of regular expressions (regex)"
HOMEPAGE="https://bitbucket.org/haypo/hachoir/wiki/hachoir-regex https://pypi.python.org/pypi/hachoir-regex"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

python_configure_all() {
	mydistutilsargs=(
		--setuptools
	)
}

python_test() {
	"${PYTHON}" test_doc.py || die "Tests fail with ${EPYTHON}"
}
