# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

MY_PN=${PN/-/.}
MY_PN=${MY_PN//-/_}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Backport of the ssl.match_hostname function"
HOMEPAGE="https://pypi.python.org/pypi/backports.ssl_match_hostname/"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="PYTHON"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/backports[${PYTHON_USEDEP}]"

S=${WORKDIR}/${MY_P}

python_install_all() {
	local DOCS=( backports/ssl_match_hostname/README.txt )
	distutils-r1_python_install_all
}

python_install() {
	# main namespace provided by dev-python/backports
	rm "${BUILD_DIR}"/lib/backports/__init__.py || die
	rm -f backports/__init__.py || die
	distutils-r1_python_install
}
