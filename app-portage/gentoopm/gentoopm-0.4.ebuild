# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="A common interface to Gentoo package managers"
HOMEPAGE="https://github.com/mgorny/gentoopm/"
SRC_URI="
	https://github.com/mgorny/gentoopm/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~mips ~sparc x86 ~x64-macos"

RDEPEND="
	|| (
		>=sys-apps/pkgcore-0.9.4[${PYTHON_USEDEP}]
		>=sys-apps/portage-2.1.10.3[${PYTHON_USEDEP}] )"
PDEPEND="app-eselect/eselect-package-manager"

distutils_enable_tests pytest

python_test() {
	if has_version ">=sys-apps/pkgcore-0.9.4[${PYTHON_USEDEP}]"; then
		einfo "Testing against pkgcore ..."
		PACKAGE_MANAGER=pkgcore epytest
	fi
	if has_version ">=sys-apps/portage-2.1.10.3[${PYTHON_USEDEP}]"; then
		einfo "Testing against portage ..."
		PACKAGE_MANAGER=portage epytest
	fi
}
