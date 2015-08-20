# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

MY_PN=${PN/-/.}
MY_PN=${MY_PN//-/_}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Backport of the ssl.match_hostname function"
HOMEPAGE="https://pypi.python.org/pypi/backports.ssl_match_hostname/"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="PYTHON"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ppc ppc64 x86 ~amd64-linux ~x86-linux"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/backports[${PYTHON_USEDEP}]"

S=${WORKDIR}/${MY_P}

python_prepare_all() {
	# prevent unnecessary docs from being installed in site-packages
	mv src/backports/ssl_match_hostname/{LICENSE,README}.txt "${S}" || die
	distutils-r1_python_prepare_all
}

python_install_all() {
	local DOCS=( README.txt )
	distutils-r1_python_install_all
}

python_install() {
	distutils-r1_python_install

	# main namespace provided by dev-python/backports
	rm "${ED}$(python_get_sitedir)"/backports/__init__.py* || die
}
