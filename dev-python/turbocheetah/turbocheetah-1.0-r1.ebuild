# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/turbocheetah/turbocheetah-1.0-r1.ebuild,v 1.1 2015/01/10 07:46:39 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1
#DISTUTILS_SRC_TEST="nosetests"

MY_PN="TurboCheetah"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="TurboGears plugin to support use of Cheetah templates"
HOMEPAGE="http://docs.turbogears.org/TurboCheetah http://pypi.python.org/pypi/TurboCheetah"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-python/cheetah-2.0.1[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}"

python_test() {
	nosetests || die "test failed"
}
