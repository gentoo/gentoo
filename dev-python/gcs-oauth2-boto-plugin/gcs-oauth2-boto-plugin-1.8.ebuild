# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="OAuth 2.0 plugin for Google Cloud Storage credentials in the Boto library"
HOMEPAGE="https://pypi.python.org/pypi/gcs-oauth2-boto-plugin"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

PATCHES=(
	"${FILESDIR}/${P}-use-friendy-version-checks.patch"
)

# Keep versions in sync with setup.py.
RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	>=dev-python/boto-2.29.1[${PYTHON_USEDEP}]
	>=dev-python/httplib2-0.8[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.13[${PYTHON_USEDEP}]
	>=dev-python/google-api-python-client-1.1[${PYTHON_USEDEP}]
	>=dev-python/retry-decorator-1.0.0[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/socksipy-1.01[${PYTHON_USEDEP}]"
