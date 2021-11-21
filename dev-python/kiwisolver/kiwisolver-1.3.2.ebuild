# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

# tagging fail?
MY_PV=${PV}.rc1
DESCRIPTION="An efficient C++ implementation of the Cassowary constraint solving algorithm"
HOMEPAGE="https://github.com/nucleic/kiwi"
SRC_URI="https://github.com/nucleic/kiwi/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/kiwi-${MY_PV}

LICENSE="Clear-BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/cppy-1.1.0[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${PN}-1.3.1-darwin-build.patch"
)

distutils_enable_tests pytest
