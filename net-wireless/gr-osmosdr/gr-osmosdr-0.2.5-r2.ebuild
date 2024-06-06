# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..12} )

inherit cmake python-single-r1

DESCRIPTION="GNU Radio source block for OsmoSDR and rtlsdr and hackrf"
HOMEPAGE="
	https://sdr.osmocom.org/trac/wiki/GrOsmoSDR
	https://gitea.osmocom.org/sdr/gr-osmosdr
"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitea.osmocom.org/sdr/gr-osmosdr.git"
else
	SRC_URI="https://gitea.osmocom.org/sdr/gr-osmosdr/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~riscv ~x86"
	S="${WORKDIR}/${PN}"
fi

LICENSE="GPL-3"
SLOT="0/${PV}"
IUSE="airspy bladerf doc hackrf iqbalance rtlsdr sdrplay soapy uhd xtrx"

RDEPEND="${PYTHON_DEPS}
	dev-libs/boost:=
	dev-libs/log4cpp
	net-wireless/gnuradio:0=[${PYTHON_SINGLE_USEDEP}]
	sci-libs/volk:=
	airspy? ( net-wireless/airspy )
	bladerf? ( >=net-wireless/bladerf-2018.08_rc1:= )
	hackrf? ( net-libs/libhackrf:= )
	iqbalance? ( net-wireless/gr-iqbal:=[${PYTHON_SINGLE_USEDEP}] )
	rtlsdr? ( >=net-wireless/rtl-sdr-0.5.4:= )
	sdrplay? ( net-wireless/sdrplay )
	soapy? ( net-wireless/soapysdr:= )
	uhd? ( net-wireless/uhd:=[${PYTHON_SINGLE_USEDEP}] )
	xtrx? ( net-wireless/libxtrx )
	"
DEPEND="${RDEPEND}"

BDEPEND="
		$(python_gen_cond_dep 'dev-python/pybind11[${PYTHON_USEDEP}]')
		doc? ( app-text/doxygen )
	"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

PATCHES=(
	"${FILESDIR}/${PN}-0.2.3_p20210128-fix-enable-python.patch"
)

src_configure() {
	local mycmakeargs=(
		-DENABLE_DEFAULT=OFF
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DENABLE_FILE=ON
		-DENABLE_AIRSPY="$(usex airspy ON OFF)"
		-DENABLE_BLADERF="$(usex bladerf ON OFF)"
		-DENABLE_HACKRF="$(usex hackrf ON OFF)"
		-DENABLE_IQBALANCE="$(usex iqbalance ON OFF)"
		-DENABLE_PYTHON=ON
		-DENABLE_RTL="$(usex rtlsdr ON OFF)"
		-DENABLE_RTL_TCP="$(usex rtlsdr ON OFF)"
		-DENABLE_SDRPLAY="$(usex sdrplay ON OFF)"
		-DENABLE_NONFREE="$(usex sdrplay ON OFF)"
		-DENABLE_SOAPY="$(usex soapy ON OFF)"
		-DENABLE_UHD="$(usex uhd ON OFF)"
		-DENABLE_XTRX="$(usex xtrx ON OFF)"
		-DENABLE_DOXYGEN="$(usex doc ON OFF)"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	find "${ED}" -name '*.py[oc]' -delete || die
	python_fix_shebang "${ED}"/usr/bin
	python_optimize
}
