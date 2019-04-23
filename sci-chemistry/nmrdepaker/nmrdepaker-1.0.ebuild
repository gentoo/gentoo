# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DISTUTILS_SINGLE_IMPL="yes"
PYTHON_COMPAT=( python2_7 )

inherit desktop distutils-r1

DESCRIPTION="Program to perform NMR spectra 'De-Pake-ing' and moment calculation"
HOMEPAGE="https://launchpad.net/nmrdepaker"
SRC_URI="https://launchpad.net/${PN}/${PV}/${PV}/+download/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3+"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=dev-python/matplotlib-0.98.5[gtk2,${PYTHON_USEDEP}]
	>=dev-python/numpy-1.2[${PYTHON_USEDEP}]
	>=dev-python/pygtk-2.12:2[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/nmrdpaker-${PV}"

src_install() {
	distutils-r1_src_install

	newicon lib/data/images/unused/nmrfriend-buddy.svg ${PN}.svg
	make_desktop_entry ${PN}
}
