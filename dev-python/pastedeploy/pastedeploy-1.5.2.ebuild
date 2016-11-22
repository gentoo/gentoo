# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

MY_PN="PasteDeploy"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Load, configure, and compose WSGI applications and servers"
HOMEPAGE="http://pythonpaste.org/deploy/ https://pypi.python.org/pypi/PasteDeploy"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 hppa ~ia64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="doc"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

python_install_all() {
	distutils-r1_python_install_all

	use doc && dodoc docs/*.txt
}
