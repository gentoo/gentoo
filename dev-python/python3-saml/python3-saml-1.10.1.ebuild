# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="OneLogin's SAML Python Toolkit"
HOMEPAGE="https://github.com/onelogin/python3-saml
	https://pypi.org/project/python3-saml/"
SRC_URI="https://github.com/onelogin/python3-saml/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

RDEPEND="
	>=dev-python/isodate-0.5.0[${PYTHON_USEDEP}]
	>=dev-python/lxml-3.3.5[${PYTHON_USEDEP}]
	>=dev-python/python-xmlsec-1.0.5[${PYTHON_USEDEP}]
	>=dev-python/defusedxml-0.6.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/freezegun[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests setup.py

src_prepare() {
	# unpin deps
	sed -i -e 's:==:>=:' setup.py || die
	distutils-r1_src_prepare
}
