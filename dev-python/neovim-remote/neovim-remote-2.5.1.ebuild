# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mhinz/${PN}.git"
else
	SRC_URI="
		https://github.com/mhinz/${PN}/archive/v${PV}.tar.gz
			-> ${P}.gh.tar.gz
	"
	KEYWORDS="~amd64 ~arm"
fi

DESCRIPTION="A tool that helps control neovim processes"
HOMEPAGE="
	https://github.com/mhinz/neovim-remote/
	https://pypi.org/project/neovim-remote/
"

LICENSE="MIT"
SLOT="0"

RDEPEND="
	dev-python/pynvim[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		app-editors/neovim
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.5.1-neovim-0.8.patch
)

distutils_enable_tests pytest
