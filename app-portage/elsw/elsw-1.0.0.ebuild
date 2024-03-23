# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Tool providing a nice way to view the Portage world file"
HOMEPAGE="https://gitlab.com/xgqt/python-elsw/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://gitlab.com/xgqt/python-${PN}.git"
else
	inherit pypi

	KEYWORDS="amd64 ~arm ~arm64 ~riscv ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"

RDEPEND="
	dev-python/colorama[${PYTHON_USEDEP}]
	sys-apps/portage[${PYTHON_USEDEP}]
"

DOCS=( README.md )
