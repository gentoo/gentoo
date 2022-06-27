# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{7..11} pypy3 )

DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="alabaster sub-theme used on git-pull docs"
HOMEPAGE="https://github.com/git-pull/alagitpull"
SRC_URI="https://github.com/git-pull/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
SLOT="0"

RDEPEND="
	<dev-python/alabaster-0.8[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}"

# no tests...
