# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
PYTHON_COMPAT=( python3_{8,9,10,11} )

inherit python-r1

DESCRIPTION="A helper program for maintaining the package.keyword and package.unmask files"
HOMEPAGE="https://github.com/mpagano/portpeek"
SRC_URI="https://github.com/mpagano/portpeek/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~sparc ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	>=app-portage/gentoolkit-0.6.1-r3
	|| (
		>=sys-apps/portage-3.0.38.1-r2[${PYTHON_USEDEP}]
	)"

src_install() {
	python_foreach_impl python_doscript ${PN}
	doman *.[0-9]
}
