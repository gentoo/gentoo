# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Soapy SDR plugins for UHD supported SDR devices"
HOMEPAGE="https://github.com/pothosware/SoapyUHD"

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="https://github.com/pothosware/SoapyUHD.git"
	inherit git-r3
else
	KEYWORDS="amd64 ~arm ~riscv ~x86"
	COMMIT="2a5d381f68fd05d5b3c0e7db56c36892ea99b4ae"
	SRC_URI="https://github.com/pothosware/SoapyUHD/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/SoapyUHD-${COMMIT}
fi

LICENSE="MIT"
SLOT="0"

RDEPEND="net-wireless/soapysdr:=
		net-wireless/uhd:=
		dev-libs/boost:="
DEPEND="${RDEPEND}"
