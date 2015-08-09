# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="DNS Benchmark Utility"
HOMEPAGE="http://code.google.com/p/namebench/"
SRC_URI="http://namebench.googlecode.com/files/${P}-source.tgz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X"

# PYTHON_REQ_USE does not support X? ( tk ) syntax yet
DEPEND="X? ( $(python_gen_cond_dep dev-lang/python:2.7[tk] python2_7) )"
RDEPEND="${DEPEND}
	>=dev-python/dnspython-1.8.0[${PYTHON_USEDEP}]
	>=dev-python/httplib2-0.6[${PYTHON_USEDEP}]
	>=dev-python/graphy-1.0[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.2.1[${PYTHON_USEDEP}]
	>=dev-python/simplejson-2.1.2[${PYTHON_USEDEP}]"

python_prepare_all() {
	# don't include bundled libraries
	export NO_THIRD_PARTY=1

	distutils-r1_python_prepare_all
}

python_install() {
	#set prefix
	distutils-r1_python_install --install-data=/usr/share
}

python_install_all() {
	dosym ${PN}.py /usr/bin/${PN}
	distutils-r1_python_install_all
}
