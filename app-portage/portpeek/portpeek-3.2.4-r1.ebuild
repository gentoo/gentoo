# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
PYTHON_COMPAT=( python3_{9,10,11,12,13} )

inherit python-r1

DESCRIPTION="A helper program for maintaining the package.keyword and package.unmask files"
HOMEPAGE="https://github.com/mpagano/portpeek"
SRC_URI="https://github.com/mpagano/portpeek/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~riscv ~sparc ~x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	>=app-portage/gentoolkit-0.6.7
	|| (
		>=sys-apps/portage-3.0.65-r1[${PYTHON_USEDEP}]
	)"

src_install() {
	python_foreach_impl python_doscript ${PN}
	doman *.[0-9]
}
