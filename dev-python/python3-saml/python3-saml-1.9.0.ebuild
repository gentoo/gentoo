# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
inherit distutils-r1

DESCRIPTION="OneLogin's SAML Python Toolkit"
HOMEPAGE="https://github.com/onelogin/python3-saml
	https://pypi.org/project/python3-saml/"
SRC_URI="https://github.com/onelogin/python3-saml/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

CDEPEND="
	dev-python/isodate[${PYTHON_USEDEP}]
	dev-python/python-xmlsec[${PYTHON_USEDEP}]
	dev-python/defusedxml[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/freezegun[${PYTHON_USEDEP}]
	)
"
RDEPEND="${CDEPEND}"

distutils_enable_tests setup.py
