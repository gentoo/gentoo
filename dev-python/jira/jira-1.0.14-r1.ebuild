# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
inherit distutils-r1

DESCRIPTION="Python library for interacting with the JIRA REST API"
HOMEPAGE="https://jira.readthedocs.io/en/latest/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="filemagic jirashell kerberos oauth"

DEPEND="
	>=dev-python/pbr-3.0[${PYTHON_USEDEP}]
	dev-python/pytest-runner[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	"
RDEPEND="
	dev-python/defusedxml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/requests-toolbelt[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	filemagic? ( dev-python/filemagic[${PYTHON_USEDEP}] )
	jirashell? (
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/requests-oauthlib[${PYTHON_USEDEP}]
	)
	kerberos? ( $(python_gen_cond_dep 'dev-python/requests-kerberos[${PYTHON_USEDEP}]' -3) )
	oauth? (
		|| ( dev-python/pycryptodome[${PYTHON_USEDEP}] dev-python/pycrypto[${PYTHON_USEDEP}] )
		dev-python/requests-oauthlib[${PYTHON_USEDEP}]
	)
	"

REQUIRED_USE="kerberos? ( !python_targets_python2_7 )"
