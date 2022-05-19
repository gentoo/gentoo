# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Python library to work with countries and languages"
HOMEPAGE="
	https://github.com/Diaoul/babelfish/
	https://pypi.org/project/babelfish/
"
SRC_URI="
	https://github.com/Diaoul/babelfish/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

distutils_enable_tests pytest
