# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{12..13} )

inherit cmake python-single-r1

DESCRIPTION="gnuradio I/Q balancing"
HOMEPAGE="http://git.osmocom.org/gr-iqbal/"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/osmocom/gr-iqbal.git"
else
	SRC_URI="https://github.com/osmocom/gr-iqbal/archive/refs/tags/v${PV}.tar.gz -> "${P}.gh.tar.gz""
	KEYWORDS="~amd64 ~arm ~riscv ~x86"
fi

LICENSE="GPL-3"
SLOT="0/${PV}"
IUSE="doc"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RDEPEND=">=net-wireless/gnuradio-3.9.0.0:0=[${PYTHON_SINGLE_USEDEP}]
	net-libs/libosmo-dsp:=
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	dev-libs/boost"

PATCHES=( "${FILESDIR}/${PN}-boost-no-system.patch" )

src_configure() {
	local mycmakeargs=(
		-DENABLE_DOXYGEN="$(usex doc)"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	find  "${D}" -name '__init__.py[co]' -delete || die
	python_optimize
	mv "${ED}/usr/share/doc/gr-iqbalance" "${ED}/usr/share/doc/${P}"
}
