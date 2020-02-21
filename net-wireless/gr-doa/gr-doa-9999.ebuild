# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils git-r3 python-single-r1

DESCRIPTION="Gnuradio flowgraphs and modules for Direction of Arrival analysis"
HOMEPAGE="https://github.com/samwhiting/gnuradio-doa"
EGIT_REPO_URI="https://github.com/samwhiting/gnuradio-doa.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="doc"
#Tests fail, https://github.com/samwhiting/gnuradio-doa/issues/3
RESTRICT="test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	>=net-wireless/gnuradio-3.7.0:=[${PYTHON_SINGLE_USEDEP}]
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig"

S="${WORKDIR}/${P}/gr-doa"

src_configure() {
	mycmakeargs=(
		-DPYTHON_EXECUTABLE="${PYTHON}"
	)
	cmake-utils_src_configure
}
src_install() {
	cmake-utils_src_install
	insinto /usr/share/${PN}
	doins -r "${WORKDIR}/${P}/flowgraphs"
}
