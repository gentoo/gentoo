# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="OneLogin's SAML Python Toolkit"
HOMEPAGE="https://github.com/onelogin/python3-saml
	https://pypi.org/project/python3-saml/"
SRC_URI="
	https://github.com/onelogin/python3-saml/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

RDEPEND="
	>=dev-python/isodate-0.6.1[${PYTHON_USEDEP}]
	>=dev-python/lxml-4.7.0[${PYTHON_USEDEP}]
	>=dev-python/python-xmlsec-1.3.9[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests setup.py

src_prepare() {
	# unpin deps
	sed -e '/lxml/s/</>=/' -i setup.py || die
	distutils-r1_src_prepare
}
