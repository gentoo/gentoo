# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

DESCRIPTION="Remote video eavesdropping using a software-defined radio platform"
HOMEPAGE="https://github.com/deltj/TempestSDR.git"

LICENSE="GPL-3"
SLOT="0"
IUSE="airspy"
if [ "${PV}" = "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/deltj/TempestSDR.git"
else
	KEYWORDS="~amd64 ~x86"
	COMMIT="59201a2cb21ab193125719eb318dcfbbf979c32e"
	SRC_URI="https://github.com/deltj/TempestSDR/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/TempestSDR-${COMMIT}"
fi

RDEPEND=">=virtual/jre-1.8:*
	dev-libs/boost:=
	airspy? ( net-wireless/airspy )
	net-wireless/uhd:=
	net-wireless/rtl-sdr:=
	net-wireless/bladerf:=
	net-wireless/hackrf-tools"
DEPEND=">=virtual/jdk-1.8:*
	${RDEPEND}"

src_prepare() {
	rm -r TSDRPlugin_Airspy
	default
}

src_install() {
	java-pkg_dojar JavaGUI/JTempestSDR.jar
	java-pkg_dolauncher tempestsdr --jar JTempestSDR.jar
}
