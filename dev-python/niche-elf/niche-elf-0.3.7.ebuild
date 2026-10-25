# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pwndbg/niche-elf.git"
else
	inherit pypi
	KEYWORDS="~amd64 ~arm64"
fi

DESCRIPTION="Library that optimizes some niche operations used by debugger extensions"
HOMEPAGE="
	https://pypi.org/project/niche-elf/
	https://github.com/pwndbg/niche-elf
"

LICENSE="GPL-3"
SLOT="0"

PATCHES=(
	"${FILESDIR}/${PN}-build-backend.patch"
)

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
