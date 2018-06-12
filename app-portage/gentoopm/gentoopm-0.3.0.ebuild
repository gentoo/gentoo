# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy )

inherit distutils-r1

DESCRIPTION="A common interface to Gentoo package managers"
HOMEPAGE="https://github.com/mgorny/gentoopm/"
SRC_URI="https://github.com/mgorny/gentoopm/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm ~mips x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="
	|| (
		>=sys-apps/pkgcore-0.9.4[${PYTHON_USEDEP}]
		>=sys-apps/portage-2.1.10.3[${PYTHON_USEDEP}]
		sys-apps/portage-mgorny[${PYTHON_USEDEP}]
		>=sys-apps/paludis-3.0.0_pre20170219[python,${PYTHON_USEDEP}] )"
PDEPEND="app-eselect/eselect-package-manager"

python_test() {
	esetup.py test
}
