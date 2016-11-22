# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

DESCRIPTION="Simplified object-oriented Python extension module for libpcap"
HOMEPAGE="https://github.com/pynetwork/pypcap https://pypi.python.org/pypi/pypcap"
SRC_URI="https://github.com/pynetwork/pypcap/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"

RDEPEND="net-libs/libpcap"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

python_compile() {
	local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	distutils-r1_python_compile
}
