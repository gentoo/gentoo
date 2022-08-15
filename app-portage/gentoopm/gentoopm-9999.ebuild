# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1 git-r3

DESCRIPTION="A common interface to Gentoo package managers"
HOMEPAGE="https://github.com/projg2/gentoopm/"
EGIT_REPO_URI="https://github.com/projg2/gentoopm.git"

LICENSE="BSD-2"
SLOT="0"

RDEPEND="
	|| (
		>=sys-apps/pkgcore-0.9.4[${PYTHON_USEDEP}]
		>=sys-apps/portage-2.1.10.3[${PYTHON_USEDEP}] )"
PDEPEND="app-eselect/eselect-package-manager"

distutils_enable_tests pytest
