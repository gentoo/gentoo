# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="An efficient C++ implementation of the Cassowary constraint solving algorithm"
HOMEPAGE="https://github.com/nucleic/kiwi"
SRC_URI="https://github.com/nucleic/kiwi/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/kiwi-${PV}

LICENSE="Clear-BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ppc64 ~sparc x86"

RDEPEND="
	>=dev-python/cppy-1.1.0[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${PN}-1.3.1-darwin-build.patch"
)

distutils_enable_tests pytest
