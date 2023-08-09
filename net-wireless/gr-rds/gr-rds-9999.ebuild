# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/bastibl/${PN}"
	EGIT_BRANCH="maint-3.10"
else
	KEYWORDS="~amd64 ~x86"
	COMMIT="f3646d04c138dc3279528808dcf6f847887e4a4f"
	SRC_URI="https://github.com/bastibl/gr-rds/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
fi
inherit cmake python-single-r1

DESCRIPTION="GNU Radio FM RDS Receiver"
HOMEPAGE="https://github.com/bastibl/gr-rds"

LICENSE="GPL-3"
SLOT="0/${PV}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-libs/boost:=[python,${PYTHON_USEDEP}]
	')
	net-wireless/gnuradio:0=[${PYTHON_SINGLE_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/swig:0
"

src_configure() {
	local mycmakeargs=( -DPYTHON_EXECUTABLE="${PYTHON}" )
	cmake_src_configure
}

src_install() {
	cmake_src_install
	python_optimize
}
