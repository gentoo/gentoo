# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=(python2_7 python3_4)
inherit distutils-r1

DESCRIPTION="Python library for interacting with the JIRA REST API"
HOMEPAGE="http://jira-python.readthedocs.org/en/latest/"
SRC_URI="https://github.com/pycontribs/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="filemagic ipython oauth"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	filemagic? ( dev-python/filemagic[${PYTHON_USEDEP}] )
	ipython? ( dev-python/ipython[${PYTHON_USEDEP}] )
	oauth? (
		dev-python/requests-oauthlib[${PYTHON_USEDEP}]
		dev-python/tlslite[${PYTHON_USEDEP}]
		dev-python/pycrypto[${PYTHON_USEDEP}]
	)
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
