# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 java-pkg-2

DESCRIPTION="Remote video eavesdropping using a software-defined radio platform"
HOMEPAGE="https://github.com/deltj/TempestSDR.git"
EGIT_REPO_URI="https://github.com/deltj/TempestSDR.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=virtual/jdk-1.7:*
		net-wireless/airspy
		net-wireless/uhd:=
		net-wireless/rtl-sdr
		net-wireless/bladerf:=
		net-wireless/hackrf-tools"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	#airspy mini support, but may degrade airspy support, needs testing
	#sed -i -e 's#10e6#6e6#g' -e 's#10000000#6000000#g' TSDRPlugin_Airspy/src/TSDRPlugin_Airspy.cpp
	default
}

src_compile() {
	emake all
}

src_install() {
	insinto /usr/share/${PN}
	doins JavaGUI/JTempestSDR.jar
	dodir /usr/bin
	cat <<-EOF > "${ED}/usr/bin/tempestsdr"
#!/bin/sh
java -jar /usr/share/tempestsdr/JTempestSDR.jar
EOF
	fperms +x /usr/bin/tempestsdr
}
