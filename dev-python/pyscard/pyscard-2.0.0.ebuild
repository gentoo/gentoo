# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1 optfeature

DESCRIPTION="Smart cards support in python"
HOMEPAGE="https://pyscard.sourceforge.io/
	https://github.com/LudovicRousseau/pyscard
	https://pypi.org/project/pyscard/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm x86"

RDEPEND="sys-apps/pcsc-lite"
DEPEND="${RDEPEND}"
BDEPEND="dev-lang/swig"

python_test() {
	esetup.py test
}

pkg_postinst() {
	optfeature "Gui support" dev-python/wxpython
	optfeature "Support of remote readers with Pyro" dev-python/pyro
}
