# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 git-r3

DESCRIPTION="A common interface to Gentoo package managers"
HOMEPAGE="
	https://github.com/projg2/gentoopm/
	https://pypi.org/project/gentoopm/
"
EGIT_REPO_URI="https://github.com/projg2/gentoopm.git"

LICENSE="BSD-2"
SLOT="0"

RDEPEND="
	|| (
		>=sys-apps/pkgcore-0.12.19[${PYTHON_USEDEP}]
		>=sys-apps/portage-2.1.10.3[${PYTHON_USEDEP}]
	)
"
PDEPEND="
	app-eselect/eselect-package-manager
"

distutils_enable_tests pytest
