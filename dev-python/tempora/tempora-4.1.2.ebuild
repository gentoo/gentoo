# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{8..10} )
inherit distutils-r1

MY_PN="${PN/-/.}"
DESCRIPTION="Objects and routines pertaining to date and time"
HOMEPAGE="https://github.com/jaraco/tempora"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv sparc x86 ~x64-macos"

RDEPEND="
	>=dev-python/jaraco-functools-1.20[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	test? (
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/pytest-freezegun[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx docs \
	">=dev-python/jaraco-packaging-3.2" \
	">=dev-python/rst-linker-1.9"
