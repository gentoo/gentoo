# Copyright 1999-2024 Gentoo Authors
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
	COMMIT="422a9b306f765499dd3e9a4c3400fa39816dcfdb"
	SRC_URI="https://github.com/pothosware/SoapyPlutoSDR/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/SoapyPlutoSDR-${COMMIT}
fi

LICENSE="LGPL-2.1+"
SLOT="0"

RDEPEND="net-wireless/soapysdr:=
		net-libs/libiio:=
		net-libs/libad9361-iio:="
DEPEND="${RDEPEND}"
