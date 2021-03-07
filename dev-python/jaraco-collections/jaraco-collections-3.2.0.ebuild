# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )
inherit distutils-r1

MY_PN="${PN/-/.}"
DESCRIPTION="Models and classes to supplement the stdlib collections module"
HOMEPAGE="https://github.com/jaraco/jaraco.collections"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~x86"

RDEPEND="
	dev-python/jaraco-classes[${PYTHON_USEDEP}]
	dev-python/jaraco-text[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools_scm-1.15.0[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/jaraco-collections-3.0.0-pypy.patch"
)

distutils_enable_sphinx docs '>=dev-python/jaraco-packaging-3.2' \
	'>=dev-python/rst-linker-1.9'
distutils_enable_tests pytest
