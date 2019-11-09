# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 java-pkg-2

DESCRIPTION="Remote video eavesdropping using a software-defined radio platform"
HOMEPAGE="https://github.com/tanpc/TempestSDR"
EGIT_REPO_URI="https://github.com/tanpc/TempestSDR.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=virtual/jre-1.7"
DEPEND=">=virtual/jdk-1.7"
BDEPEND=""

src_prepare() {
	sed -i -e 's#javah#javac -h .#' \
		-e 's#-jni martin.tempest.core.TSDRLibrary##' \
		-e 's#-o TSDRLibraryNDK.h#../src/martin/tempest/core/TSDRLibrary.java#' JavaGUI/jni/makefile || die
	sed -i -e 's#TSDRLibraryNDK.h#martin_tempest_core_TSDRLibrary.h#g' JavaGUI/jni/TSDRLibraryNDK.c
	#airspy mini support, but may degrade airspy support, needs testing
	#sed -i -e 's#10e6#6e6#g' -e 's#10000000#6000000#g' TSDRPlugin_Airspy/src/TSDRPlugin_Airspy.cpp
	default
}

src_compile() {
	emake clean
	#this absolutely breaks in wierd ways when built parallel
	emake -j1 all
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
