# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Soapy SDR plugin for SDRPlay"
HOMEPAGE="https://github.com/pothosware/SoapySDRPlay"

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="https://github.com/pothosware/SoapySDRPlay.git"
	EGIT_CLONE_TYPE="shallow"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/pothosware/SoapySDRPlay/archive/soapy-sdrplay-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/SoapySDRPlay-soapy-sdrplay-"${PV}"
fi

LICENSE="Boost-1.0"
SLOT="0"

IUSE=""
REQUIRED_USE=""

RDEPEND="net-wireless/soapysdr
	net-wireless/sdrplay"
DEPEND="${RDEPEND}"
