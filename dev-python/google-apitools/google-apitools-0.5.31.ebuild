# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

COMMIT_HASH="7975c0cdbae1b9fc106553ce46e4a59cf0bea1e1"
DESCRIPTION="Python library to manipulate Google APIs"
HOMEPAGE="https://github.com/google/apitools"
SRC_URI="
	https://github.com/google/apitools/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
S="${WORKDIR}/${P#google-}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/httplib2-0.8[${PYTHON_USEDEP}]
	>=dev-python/fasteners-0.14[${PYTHON_USEDEP}]
	>=dev-python/oauth2client-1.5.2[${PYTHON_USEDEP}]
	>=dev-python/six-1.12.0[${PYTHON_USEDEP}]
	>=dev-python/python-gflags-3.1.2[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	>=dev-python/setuptools-18.5[${PYTHON_USEDEP}]
	test? (	>=dev-python/mock-1.0.1[${PYTHON_USEDEP}] )"

PATCHES=(
	"${FILESDIR}/google-apitools-0.5.30-py37.patch"
)

distutils_enable_tests nose
