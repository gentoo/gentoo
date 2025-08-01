# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 optfeature

DESCRIPTION="Smart card support in python"
HOMEPAGE="
	https://pyscard.sourceforge.io/
	https://github.com/LudovicRousseau/pyscard/
	https://pypi.org/project/pyscard/
"
SRC_URI="
	https://downloads.sourceforge.net/project/pyscard/pyscard/pyscard%20${PV}/${P}.tar.gz
"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

DEPEND="
	sys-apps/pcsc-lite
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-lang/swig
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

pkg_postinst() {
	optfeature "Gui support" dev-python/wxpython
	optfeature "Support of remote readers with Pyro" dev-python/Pyro4
}
