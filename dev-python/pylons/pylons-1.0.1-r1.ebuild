# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="Pylons"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Pylons Web Framework"
HOMEPAGE="http://pylonshq.com/ https://pypi.python.org/pypi/Pylons"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="genshi jinja test"

RDEPEND=">=dev-python/beaker-1.3[${PYTHON_USEDEP}]
	>=dev-python/decorator-2.3.2[${PYTHON_USEDEP}]
	>=dev-python/formencode-1.2.1[${PYTHON_USEDEP}]
	>=dev-python/mako-0.2.4[${PYTHON_USEDEP}]
	>=dev-python/nose-0.10.4[${PYTHON_USEDEP}]
	>=dev-python/paste-1.7.2[${PYTHON_USEDEP}]
	>=dev-python/pastedeploy-1.3.3[${PYTHON_USEDEP}]
	>=dev-python/pastescript-1.7.3[${PYTHON_USEDEP}]
	>=dev-python/repoze-lru-0.3[${PYTHON_USEDEP}]
	>=dev-python/routes-1.12[${PYTHON_USEDEP}]
	>=dev-python/simplejson-2.0.8[${PYTHON_USEDEP}]
	>=dev-python/tempita-0.2[${PYTHON_USEDEP}]
	>=dev-python/weberror-0.10.1[${PYTHON_USEDEP}]
	>=dev-python/webhelpers-0.6.4[${PYTHON_USEDEP}]
	>=dev-python/webob-0.9.6.1[${PYTHON_USEDEP}]
	>=dev-python/webtest-1.1[${PYTHON_USEDEP}]
	genshi? ( >=dev-python/genshi-0.4.4[${PYTHON_USEDEP}] )
	jinja? ( >=dev-python/jinja-2[${PYTHON_USEDEP}] )"
# Dependency on >=dev-python/coverage-2.85 and dev-python/genshi is not with Jython.
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/coverage-2.85[${PYTHON_USEDEP}]
		dev-python/genshi[${PYTHON_USEDEP}]
		>=dev-python/jinja-2.2.1[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MY_P}"

python_test() {
	nosetests || die "Tests fail with ${EPYTHON}"
}
