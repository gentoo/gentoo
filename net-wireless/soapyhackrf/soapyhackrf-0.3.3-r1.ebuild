# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="SoapySDR HackRF module"
HOMEPAGE="https://github.com/pothosware/SoapyHackRF"

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="https://github.com/pothosware/SoapyHackRF.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/pothosware/SoapyHackRF/archive/soapy-hackrf-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/SoapyHackRF-soapy-hackrf-"${PV}"
fi

LICENSE="MIT"
SLOT="0"

RDEPEND="net-wireless/soapysdr:=
		net-libs/libhackrf:="
DEPEND="${RDEPEND}"
