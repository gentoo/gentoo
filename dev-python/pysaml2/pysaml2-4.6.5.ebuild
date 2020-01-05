# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Python implementation of SAML Version 2 to be used in a WSGI environment"
HOMEPAGE="https://github.com/rohe/pysaml2"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

PATCHES=(
)

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=">=dev-python/cryptography-1.4[${PYTHON_USEDEP}]
	dev-python/defusedxml[${PYTHON_USEDEP}]
	dev-python/future[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	>=dev-python/requests-1.0.0[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"

python_prepare_all() {
	# Work-around for bug 675824
	# With older setuptools, version = file:... is not supported, see Note 1 in:
	#   https://setuptools.readthedocs.io/en/latest/setuptools.html#metadata
	# In such cases, hardcode the version
	has_version ">=dev-python/setuptools-39.2.0" || \
		sed --in-place "s/^version = file:.*\$/version = ${PV}/" setup.cfg
	##
	distutils-r1_python_prepare_all
}
