# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_{4,5}} )

inherit distutils-r1 eutils

DESCRIPTION="Smart cards support in python"
HOMEPAGE="http://pyscard.sourceforge.net/ https://pypi.python.org/pypi/pyscard"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE=""

RDEPEND="sys-apps/pcsc-lite"
DEPEND="${RDEPEND}
	dev-python/setuptools
	dev-lang/swig"

# Fails
RESTRICT=test

python_test() {
	esetup.py test
}

pkg_postinst() {
	optfeature "Gui support" dev-python/wxpython
	optfeature "Support of remote readers with Pyro" dev-python/pyro
}
