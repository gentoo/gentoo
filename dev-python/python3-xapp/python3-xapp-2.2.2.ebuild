# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9,10} )

inherit distutils-r1

DESCRIPTION="Python bindings for x11-libs/xapp"
HOMEPAGE="https://github.com/linuxmint/python3-xapp"
SRC_URI="https://github.com/linuxmint/python3-xapp/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
IUSE=""

DEPEND="
	>=x11-libs/xapp-2.2.0[introspection]
"
RDEPEND="
	${DEPEND}
	dev-python/psutil[${PYTHON_USEDEP}]
"
