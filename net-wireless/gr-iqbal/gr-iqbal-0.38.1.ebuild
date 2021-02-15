# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8,9})

inherit cmake python-single-r1

DESCRIPTION="gnuradio I/Q balancing"
HOMEPAGE="http://git.osmocom.org/gr-iqbal/"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/osmocom/gr-iqbal.git"
else
	SRC_URI="https://github.com/osmocom/gr-iqbal/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="GPL-3"
SLOT="0/${PV}"
IUSE="doc"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RDEPEND="=net-wireless/gnuradio-3.8*:0=[${PYTHON_SINGLE_USEDEP}]
	net-libs/libosmo-dsp:=
	dev-libs/boost:=
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DENABLE_DOXYGEN="$(usex doc)"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	python_optimize
}
