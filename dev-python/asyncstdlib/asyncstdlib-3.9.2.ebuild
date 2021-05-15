# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=pyproject.toml
PYTHON_COMPAT=( python3_{7..10} )
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

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	' python3_7)"

distutils_enable_tests pytest
