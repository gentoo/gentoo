# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="The missing async toolbox"
HOMEPAGE="
	https://github.com/maxfischer2781/asyncstdlib/
	https://pypi.org/project/asyncstdlib/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	test? (
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
