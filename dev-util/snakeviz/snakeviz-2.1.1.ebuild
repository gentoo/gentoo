# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="A web-based viewer for Python profiler output"
HOMEPAGE="https://github.com/jiffyclub/snakeviz"
SRC_URI="https://github.com/jiffyclub/snakeviz/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="$(python_gen_cond_dep '
		dev-python/tornado[${PYTHON_USEDEP}]
	')"

distutils_enable_tests pytest
