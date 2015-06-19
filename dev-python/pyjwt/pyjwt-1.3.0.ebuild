# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyjwt/pyjwt-1.3.0.ebuild,v 1.3 2015/06/13 10:26:50 ago Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit eutils distutils-r1

MY_PN="PyJWT"

DESCRIPTION="JSON Web Token implementation in Python"
HOMEPAGE="http://github.com/progrium/pyjwt https://pypi.python.org/pypi/PyJWT/"
#SRC_URI="https://github.com/progrium/${P}/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE=" MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND=""
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/pytest-runner[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
	)
"
S="${WORKDIR}"/${MY_PN}-${PV}

python_prepare_all() {
	find . -name '__pycache__' -prune -exec rm -rf {} \; || die "Cleaning __pycache__ failed"
	find . -name '*.pyc' -exec rm -f {} \; || die "Cleaing *.pyc failed"

	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}

pkg_postinst() {
	elog "Available optional features:"
	optfeature "cryptography" dev-python/cryptography
	optfeature "flake8" dev-python/flake8

	ewarn "flake8 feature requires 'flake8-import-order' and 'pep8-naming', which are not in portage yet"
}
