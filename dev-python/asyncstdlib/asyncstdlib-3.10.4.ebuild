# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="The missing async toolbox"
HOMEPAGE="
	https://github.com/maxfischer2781/asyncstdlib/
	https://pypi.org/project/asyncstdlib/"
SRC_URI="
	https://github.com/maxfischer2781/asyncstdlib/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_tests pytest
