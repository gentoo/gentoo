# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

COMMIT="e91af3da6d075c0ebf718d3f82760d03bbab8081"

DESCRIPTION="Packages testing tools for Gentoo"
HOMEPAGE="https://github.com/slashbeast/pkg-testing-tools"
SRC_URI="https://github.com/slashbeast/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

RDEPEND="sys-apps/portage[${PYTHON_USEDEP}]"

S="${WORKDIR}/${PN}-${COMMIT}"
