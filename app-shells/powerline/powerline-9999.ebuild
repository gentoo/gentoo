# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..13} )
PYPI_NO_NORMALIZE=1
PYPI_PN="powerline-status"
DISTUTILS_USE_PEP517=setuptools
# tests restricted due to https://github.com/powerline/powerline/issues/2128
RESTRICT="test"
inherit distutils-r1

DESCRIPTION="The ultimate statusline/prompt utility"
HOMEPAGE="https://github.com/powerline/powerline"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/powerline/powerline"
	EGIT_BRANCH="develop"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0"
