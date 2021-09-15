# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Packages testing tools for Gentoo"
HOMEPAGE="https://github.com/slashbeast/pkg-testing-tools"
SRC_URI="https://github.com/slashbeast/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	sys-apps/portage[${PYTHON_USEDEP}]
"
