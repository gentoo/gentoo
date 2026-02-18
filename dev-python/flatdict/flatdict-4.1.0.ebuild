# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Python module for interacting with nested dicts"
HOMEPAGE="
	https://github.com/gmr/flatdict/
	https://pypi.org/project/flatdict/
"
SRC_URI="
	https://github.com/gmr/flatdict/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
