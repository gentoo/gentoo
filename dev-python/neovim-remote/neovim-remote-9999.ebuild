# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mhinz/${PN}.git"
else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/mhinz/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="A tool that helps control neovim processes"
HOMEPAGE="https://github.com/mhinz/neovim-remote"
LICENSE="MIT"
SLOT="0"

RDEPEND="
	dev-python/neovim-python-client[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
