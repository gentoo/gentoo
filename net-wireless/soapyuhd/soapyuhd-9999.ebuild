# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Soapy SDR plugins for UHD supported SDR devices"
HOMEPAGE="https://github.com/pothosware/SoapyUHD"

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="https://github.com/pothosware/SoapyUHD.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm ~riscv ~x86"
	SRC_URI="https://github.com/pothosware/SoapyUHD/archive/soapy-uhd-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/SoapyUHD-soapy-uhd-"${PV}"
	# picked up from git repo
	PATCHES=( "${FILESDIR}"/${P}-uhd-4.8.patch )
fi

LICENSE="MIT"
SLOT="0"

RDEPEND="net-wireless/soapysdr:=
		net-wireless/uhd:=
		dev-libs/boost:="
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e "s/2.8.7/3.5/" CMakeLists.txt || die
	cmake_src_prepare
}
