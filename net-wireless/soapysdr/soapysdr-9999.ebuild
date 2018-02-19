# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit cmake-utils python-r1

DESCRIPTION="vendor and platform neutral SDR support library"
HOMEPAGE="https://github.com/pothosware/SoapySDR"

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="https://github.com/pothosware/SoapySDR.git"
	EGIT_CLONE_TYPE="shallow"
	KEYWORDS=""
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/pothosware/SoapySDR/archive/soapy-sdr-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/SoapySDR-soapy-sdr-"${PV}"
fi

LICENSE="Boost-1.0"
SLOT="0"

IUSE="bladerf hackrf python rtlsdr uhd"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	python? ( dev-lang/swig:0 )
"
PDEPEND="bladerf? ( net-wireless/soapybladerf )
		hackrf? ( net-wireless/soapyhackrf )
		rtlsdr? ( net-wireless/soapyrtlsdr )
		uhd? ( net-wireless/soapyuhd )"

src_configure() {
	configuration() {
		mycmakeargs+=( -DENABLE_PYTHON=ON )
		if python_is_python3; then
			mycmakeargs+=( -DBUILD_PYTHON3=ON )
		fi
	}

	if use python; then
		python_foreach_impl configuration
	fi

	cmake-utils_src_configure
}
