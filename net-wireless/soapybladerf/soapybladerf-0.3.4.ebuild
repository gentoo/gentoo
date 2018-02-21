# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Soapy SDR plugin for the Blade RF "
HOMEPAGE="https://github.com/pothosware/SoapyBladeRF"

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="https://github.com/pothosware/SoapyBladeRF.git"
	inherit git-r3
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/pothosware/SoapyBladeRF/archive/soapy-bladerf-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/SoapyBladeRF-soapy-bladerf-"${PV}"
fi

LICENSE="MIT"
SLOT="0"

RDEPEND="net-wireless/soapysdr
		>=net-wireless/bladerf-2017.12_rc1:="
DEPEND="${RDEPEND}"
