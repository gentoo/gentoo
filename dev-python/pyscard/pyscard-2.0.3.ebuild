# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1 optfeature

DESCRIPTION="Smart card support in python"
HOMEPAGE="https://pyscard.sourceforge.io/
	https://github.com/LudovicRousseau/pyscard
	https://pypi.org/project/pyscard/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"

RDEPEND="sys-apps/pcsc-lite"
DEPEND="${RDEPEND}"
BDEPEND="dev-lang/swig"

distutils_enable_tests unittest

pkg_postinst() {
	optfeature "Gui support" dev-python/wxpython
	optfeature "Support of remote readers with Pyro" dev-python/Pyro4
}

python_test() {
	cd test || die
	eunittest
}
