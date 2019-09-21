# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="SoapySDR RTL-SDR Support Module"
HOMEPAGE="https://github.com/pothosware/SoapyRTLSDR"

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="https://github.com/pothosware/SoapyRTLSDR.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/pothosware/SoapyRTLSDR/archive/soapy-rtlsdr-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/SoapyRTLSDR-soapy-rtlsdr-"${PV}"
fi

LICENSE="MIT"
SLOT="0"

RDEPEND="net-wireless/soapysdr:=
		net-wireless/rtl-sdr"
DEPEND="${RDEPEND}"
