# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="Pylons"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Pylons Web Framework"
HOMEPAGE="http://pylonshq.com/ http://pypi.python.org/pypi/Pylons"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="genshi jinja test"

RDEPEND=">=dev-python/beaker-1.5.4[${PYTHON_USEDEP}]
		>=dev-python/decorator-3.3.2[${PYTHON_USEDEP}]
		>=dev-python/formencode-1.2.4[${PYTHON_USEDEP}]
		>=dev-python/mako-0.5.0[${PYTHON_USEDEP}]
		>=dev-python/nose-1.1.2[${PYTHON_USEDEP}]
		>=dev-python/paste-1.7.5.1[${PYTHON_USEDEP}]
		>=dev-python/pastedeploy-1.5.0[${PYTHON_USEDEP}]
		>=dev-python/pastescript-1.7.4.2[${PYTHON_USEDEP}]
		>=dev-python/repoze-lru-0.3[${PYTHON_USEDEP}]
		>=dev-python/routes-1.12.3[${PYTHON_USEDEP}]
		>=dev-python/simplejson-2.2.1[${PYTHON_USEDEP}]
		>=dev-python/tempita-0.5.1[${PYTHON_USEDEP}]
		>=dev-python/weberror-0.10.3[${PYTHON_USEDEP}]
		dev-python/webhelpers[${PYTHON_USEDEP}]
		>=dev-python/webob-1.1.1[${PYTHON_USEDEP}]
		>=dev-python/webtest-1.3.1[${PYTHON_USEDEP}]
		>=dev-python/markupsafe-0.15[${PYTHON_USEDEP}]
	genshi? ( >=dev-python/genshi-0.6[${PYTHON_USEDEP}] )
	jinja? ( >=dev-python/jinja-2[${PYTHON_USEDEP}] )"
# Dependency on >=dev-python/coverage-2.85 and dev-python/genshi is not with Jython.
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		>=dev-python/coverage-2.85[${PYTHON_USEDEP}]
	)"

REQUIRED_USE="test? ( genshi jinja )"

S="${WORKDIR}/${MY_P}"

python_test() {
	nosetests || die "Tests fail with ${EPYTHON}"
}
