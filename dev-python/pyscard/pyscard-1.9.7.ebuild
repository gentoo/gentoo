# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1 eutils

DESCRIPTION="Smart cards support in python"
HOMEPAGE="https://pyscard.sourceforge.io/
	https://github.com/LudovicRousseau/pyscard
	https://pypi.org/project/pyscard/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm x86"

RDEPEND="${PYTHON_DEP}
	sys-apps/pcsc-lite"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
BDEPEND="${PYTHON_DEP}
	dev-lang/swig"

python_test() {
	esetup.py test
}

pkg_postinst() {
	optfeature "Gui support" dev-python/wxpython
	optfeature "Support of remote readers with Pyro" dev-python/pyro
}
