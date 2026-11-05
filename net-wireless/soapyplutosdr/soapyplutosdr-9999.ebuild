# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Soapy SDR plugin for the Pluto SDR"
HOMEPAGE="https://github.com/pothosware/SoapyPlutoSDR"

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="https://github.com/pothosware/SoapyPlutoSDR.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm ~riscv ~x86"
	SRC_URI="https://github.com/pothosware/SoapyPlutoSDR/archive/soapy-plutosdr-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/SoapyPlutoSDR-soapy-plutosdr-${PV}
fi

LICENSE="LGPL-2.1+"
SLOT="0"

RDEPEND="net-wireless/soapysdr:=
		net-libs/libiio:=
		net-libs/libad9361-iio:="
DEPEND="${RDEPEND}"
