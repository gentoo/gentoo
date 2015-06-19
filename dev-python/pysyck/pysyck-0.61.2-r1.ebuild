# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pysyck/pysyck-0.61.2-r1.ebuild,v 1.1 2015/01/05 05:08:34 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

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

CFLAGS="${CFLAGS} -fno-strict-aliasing"
S="${WORKDIR}/${MY_P}"

python_test() {
	"${PYTHON}" tests/test_syck.py
	einfo "Some tests may have failed due to pending bugs in dev-libs/syck"
}
