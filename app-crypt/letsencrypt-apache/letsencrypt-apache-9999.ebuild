# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=(python2_7)

EGIT_REPO_URI="https://github.com/letsencrypt/letsencrypt.git"

inherit git-r3 distutils-r1

DESCRIPTION="Apache plugin for letsencrypt"
HOMEPAGE="https://github.com/letsencrypt/letsencrypt https://letsencrypt.org/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="test"

RDEPEND="app-crypt/letsencrypt[${PYTHON_USEDEP}]
	app-crypt/acme[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/python-augeas[${PYTHON_USEDEP}]
	dev-python/zope-component[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]"
DEPEND="test? ( ${RDEPEND}
	dev-python/nose[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]"

S=${WORKDIR}/${P}/certbot-apache

python_test() {
	nosetests || die
}
