# Copyright 1999-2023 Gentoo Authors
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
	COMMIT="b906b27e6820fe44fcc3527cc876771f7dac85d2"
	SRC_URI="https://github.com/pothosware/SoapyPlutoSDR/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/SoapyPlutoSDR-${COMMIT}
fi

LICENSE="LGPL-2.1+"
SLOT="0"

RDEPEND="net-wireless/soapysdr:=
		net-libs/libiio:=
		net-libs/libad9361-iio:="
DEPEND="${RDEPEND}"
