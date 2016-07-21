# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit java-pkg-2

MY_PV=${PV//./_}
MY_PV=${MY_PV//_pre/-build}
MY_IPV=${MY_PV//_/}

DESCRIPTION="Sun Java3D API Core"
HOMEPAGE="https://j3d-core.dev.java.net/"
SRC_URI="
	amd64? (
		http://download.java.net/media/java3d/builds/stable/${MY_PV}/java3d-${MY_PV}-linux-amd64.zip
	)
	x86? (
		http://download.java.net/media/java3d/builds/stable/${MY_PV}/java3d-${MY_PV}-linux-i586.zip
	)"
KEYWORDS="-* amd64 x86"
SLOT="0"
LICENSE="sun-jrl sun-jdl"
IUSE=""
DEPEND="app-arch/unzip"
RDEPEND=">=virtual/jre-1.4"

QA_PREBUILT="*"

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}/${A/.zip/}"
	unzip -q j3d-${MY_IPV}-linux-${ARCH}.zip || die
}

src_compile() { :; }

src_install() {
	cd "${WORKDIR}/${A/.zip/}"
	dodoc COPYRIGHT.txt README.txt

	java-pkg_dojar lib/ext/*.jar
	java-pkg_doso lib/${ARCH/x86/i386}/*.so
}

pkg_postinst() {
	elog "This ebuild installs into ${JAVA_PKG_LIBDEST} and ${JAVA_PKG_JARDEST}"
	elog 'To use this when writing your own applications you can use for example:'
	elog '-Djava.library.path=$(java-config -i sun-java3d-bin) -cp $(java-config -p sun-java3d-bin)'
}
