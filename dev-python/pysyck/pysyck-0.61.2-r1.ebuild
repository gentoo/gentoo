# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 flag-o-matic

MY_P="PySyck-${PV}"

DESCRIPTION="Python bindings for the Syck YAML parser and emitter"
HOMEPAGE="http://pyyaml.org/wiki/PySyck"
SRC_URI="http://pyyaml.org/download/pysyck/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-libs/syck-0.55"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	distutils-r1_python_prepare_all
	append-cflags -fno-strict-aliasing
}

python_test() {
	"${PYTHON}" tests/test_syck.py
	einfo "Some tests may have failed due to pending bugs in dev-libs/syck"
}
