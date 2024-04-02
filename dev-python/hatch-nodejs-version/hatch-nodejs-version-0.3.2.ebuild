# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Hatch plugin for versioning from a package.json file"
HOMEPAGE="
	https://github.com/agoose77/hatch-nodejs-version/
	https://pypi.org/project/hatch-nodejs-version/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~sparc ~x86"

RDEPEND="
	>=dev-python/hatchling-0.21.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
