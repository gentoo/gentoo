# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Python client for Neovim"
HOMEPAGE="
	https://github.com/neovim/pynvim/
	https://pypi.org/project/pynvim/
"
SRC_URI="
	https://github.com/neovim/pynvim/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	dev-python/msgpack[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/greenlet[${PYTHON_USEDEP}]
	' 'python*')
"
BDEPEND="
	test? ( app-editors/neovim )
"

distutils_enable_tests pytest
