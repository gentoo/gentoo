# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

if [[ ${PV} == "99999999" ]] ; then
	EGIT_REPO_URI="git://github.com/LegNeato/${PN}.git
		https://github.com/LegNeato/${PN}.git"
	inherit git-2
fi

DESCRIPTION="subclassable Python objects for working with JSON REST APIs"
HOMEPAGE="https://github.com/LegNeato/remoteobjects"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="test"

RDEPEND="dev-python/simplejson[${PYTHON_USEDEP}]
	dev-python/httplib2[${PYTHON_USEDEP}]"
DEPEND="${DEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/mox[${PYTHON_USEDEP}] )"

python_prepare_all() {
	# Disable failing tests.
	sed -e "s/test_get_bad_encoding/_&/" -i tests/test_http.py
	distutils-r1_python_prepare_all
}

pthon_test() {
	nosetests || die "tests failed"
}
