# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit cmake python-single-r1

DESCRIPTION="vendor and platform neutral SDR support library"
HOMEPAGE="https://github.com/pothosware/SoapySDR"
SRC_URI="https://github.com/pothosware/SoapySDR/archive/soapy-sdr-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/SoapySDR-soapy-sdr-"${PV}"
LICENSE="Boost-1.0"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm ~riscv ~x86"
IUSE="bladerf hackrf python rtlsdr plutosdr uhd airspyhf"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}"
BDEPEND="python? ( dev-lang/swig:0 )"
PDEPEND="
	airspyhf? ( net-wireless/soapyairspyhf )
	bladerf? ( net-wireless/soapybladerf )
	hackrf? ( net-wireless/soapyhackrf )
	rtlsdr? ( net-wireless/soapyrtlsdr )
	plutosdr? ( net-wireless/soapyplutosdr )
	uhd? ( net-wireless/soapyuhd )
"

PATCHES=(
	"${FILESDIR}"/soapysdr-0.8.1-python3.12-distutils.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_PYTHON=$(usex python)
		-DENABLE_PYTHON3=$(usex python)
		-DBUILD_PYTHON3=$(usex python)
		-DUSE_PYTHON_CONFIG=ON
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	use python && python_optimize
}
