# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8,9} )

inherit cmake python-single-r1

DESCRIPTION="GNU Radio source block for OsmoSDR and rtlsdr and hackrf"
HOMEPAGE="http://sdr.osmocom.org/trac/wiki/GrOsmoSDR"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/osmocom/gr-osmosdr.git"
else
	SRC_URI="https://github.com/osmocom/gr-osmosdr/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="GPL-3"
SLOT="0/${PV}"
IUSE="airspy bladerf hackrf iqbalance python rtlsdr sdrplay soapy uhd"

#xtrx? ( net-wireless/libxtrx )
RDEPEND="${PYTHON_DEPS}
	dev-libs/boost:=
	=net-wireless/gnuradio-3.8*:0=[${PYTHON_SINGLE_USEDEP}]
	sci-libs/volk:=
	airspy? ( net-wireless/airspy )
	bladerf? ( >=net-wireless/bladerf-2018.08_rc1:= )
	hackrf? ( net-libs/libhackrf:= )
	iqbalance? ( net-wireless/gr-iqbal:=[${PYTHON_SINGLE_USEDEP}] )
	rtlsdr? ( >=net-wireless/rtl-sdr-0.5.4:= )
	sdrplay? ( net-wireless/sdrplay )
	soapy? ( net-wireless/soapysdr:= )
	uhd? ( net-wireless/uhd:=[${PYTHON_SINGLE_USEDEP}] )
	"
DEPEND="${RDEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_configure() {
	#-DENABLE_XTRX="$(usex xtrx ON OFF)"
	local mycmakeargs=(
		-DENABLE_DEFAULT=OFF
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DENABLE_FILE=ON
		-DENABLE_AIRSPY="$(usex airspy ON OFF)"
		-DENABLE_BLADERF="$(usex bladerf ON OFF)"
		-DENABLE_HACKRF="$(usex hackrf ON OFF)"
		-DENABLE_IQBALANCE="$(usex iqbalance ON OFF)"
		-DENABLE_PYTHON="$(usex python ON OFF)"
		-DENABLE_RTL="$(usex rtlsdr ON OFF)"
		-DENABLE_RTL_TCP="$(usex rtlsdr ON OFF)"
		-DENABLE_SDRPLAY="$(usex sdrplay ON OFF)"
		-DENABLE_NONFREE="$(usex sdrplay ON OFF)"
		-DENABLE_SOAPY="$(usex soapy ON OFF)"
		-DENABLE_UHD="$(usex uhd ON OFF)"
		-DENABLE_XTRX=OFF
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	if use python; then
		python_fix_shebang "${ED}"/usr/bin
		python_optimize
	fi
	mv "${ED}/usr/share/doc/${PN}" "${ED}/usr/share/doc/${P}"
}
