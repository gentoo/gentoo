# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )
inherit distutils-r1

DESCRIPTION="provides a Resolver class that includes dependency resolution logic"
HOMEPAGE="https://github.com/sarugaku/resolvelib/"
SRC_URI="
	https://github.com/sarugaku/resolvelib/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	test? (
		dev-python/commentjson[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest
