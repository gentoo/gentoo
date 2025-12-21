# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1

DESCRIPTION="Packages testing tools for Gentoo"
HOMEPAGE="https://github.com/APN-Pucky/pkg-testing-tools"

REPO=APN-Pucky
LICENSE="BSD"
SLOT="0"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${REPO}/${PN}"
else
	KEYWORDS="amd64 ~arm ~arm64 ~riscv x86"
	SRC_URI="https://github.com/${REPO}/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"
fi

IUSE="test"
RESTRICT="!test? ( test )"
RDEPEND="
	sys-apps/portage[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
