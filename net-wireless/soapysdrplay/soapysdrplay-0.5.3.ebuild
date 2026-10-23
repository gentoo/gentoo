# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Soapy SDR plugin for SDRPlay"
HOMEPAGE="https://github.com/pothosware/SoapySDRPlay3"

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="https://github.com/pothosware/SoapySDRPlay3.git"
	EGIT_CLONE_TYPE="shallow"
	inherit git-r3
else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/pothosware/SoapySDRPlay3/archive/soapy-sdrplay3-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/SoapySDRPlay3-soapy-sdrplay3-${PV}
fi

LICENSE="Boost-1.0"
SLOT="0"

RDEPEND="net-wireless/soapysdr
	>=net-wireless/sdrplay-3.15.2"
DEPEND="${RDEPEND}"
