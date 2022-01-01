# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} pypy3 )
inherit distutils-r1

DESCRIPTION="A pure python RFC3339 validator"
HOMEPAGE="https://github.com/naimetti/rfc3339-validator"
SRC_URI="https://github.com/naimetti/rfc3339-validator/archive/v0.1.2.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~s390 sparc x86"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]
	dev-python/strict-rfc3339[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}
	test? ( dev-python/hypothesis[${PYTHON_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}/rfc3339-validator-0.1.2-remove-pytest-runner.patch"
)

distutils_enable_tests pytest
