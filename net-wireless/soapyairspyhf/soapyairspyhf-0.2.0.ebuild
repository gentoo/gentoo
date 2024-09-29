# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="SoapySDR Airspyhf-SDR Support Module"
HOMEPAGE="https://github.com/pothosware/SoapyAirspyHF"
SRC_URI="https://github.com/pothosware/SoapyAirspyHF/archive/soapy-airspyhf-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/SoapyAirspyHF-soapy-airspyhf-"${PV}"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~riscv ~x86"

RDEPEND="net-wireless/soapysdr:=
		net-wireless/airspyhf:="
DEPEND="${RDEPEND}"
