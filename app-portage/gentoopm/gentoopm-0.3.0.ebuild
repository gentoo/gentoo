# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_6,3_7} )

inherit distutils-r1

DESCRIPTION="A common interface to Gentoo package managers"
HOMEPAGE="https://github.com/mgorny/gentoopm/"
SRC_URI="https://github.com/mgorny/gentoopm/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm ~mips x86"
IUSE=""

RDEPEND="
	|| (
		>=sys-apps/pkgcore-0.9.4[${PYTHON_USEDEP}]
		>=sys-apps/portage-2.1.10.3[${PYTHON_USEDEP}] )"
PDEPEND="app-eselect/eselect-package-manager"

python_test() {
	esetup.py test
}
