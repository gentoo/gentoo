# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyramid/pyramid-1.5.1.ebuild,v 1.7 2015/04/08 08:05:10 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

RESTRICT="test" # Can't package dependencies

DESCRIPTION="A small open source Python web framework"
HOMEPAGE="http://www.pylonsproject.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="repoze"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
#IUSE="test"
# tests would pull in dev-python/zope-deprecation with its deps - not a good idea

RDEPEND="
	dev-python/chameleon[${PYTHON_USEDEP}]
	dev-python/mako[${PYTHON_USEDEP}]
	dev-python/webob[${PYTHON_USEDEP}]
	dev-python/repoze-lru[${PYTHON_USEDEP}]
	dev-python/mako[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
	dev-python/translationstring[${PYTHON_USEDEP}]
	dev-python/pastedeploy[${PYTHON_USEDEP}]
	dev-python/venusian[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	"
	#test? ( dev-python/webtest[${PYTHON_USEDEP}]
	#	dev-python/nose[${PYTHON_USEDEP}]
	#	dev-python/coverage[${PYTHON_USEDEP}]
	#	dev-python/virtualenv[${PYTHON_USEDEP}]
	#	)
	#"

python_test() {
	nosetests || die "Tests fail with ${EPYTHON}"
}
