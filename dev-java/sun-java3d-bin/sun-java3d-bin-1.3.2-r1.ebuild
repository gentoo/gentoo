# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit java-pkg-2

DESCRIPTION="Sun Java3D API Core"
HOMEPAGE="https://j3d-core.dev.java.net/"
SRC_URI="amd64? ( java3d-${PV//./_}-linux-amd64.zip )
	x86? ( java3d-${PV//./_}-linux-i586.zip )"
KEYWORDS="-* amd64 x86"
SLOT="0"
LICENSE="sun-jrl sun-jdl"
IUSE=""
DEPEND="app-arch/unzip"
RDEPEND=">=virtual/jre-1.3"
RESTRICT="fetch"

S=${WORKDIR}/${A/.zip/}

pkg_nofetch() {
	einfo "Please download java3d-${PV//./_}-linux-${ARCH/x86/i586}.zip from"
	einfo "${HOMEPAGE} and place it in ${DISTDIR}"
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	unzip -q j3d-132-linux-${ARCH}.zip || die
}

src_compile() { :; }

src_install() {
	dodoc COPYRIGHT.txt README.txt

	java-pkg_dojar lib/ext/*.jar
	java-pkg_doso lib/${ARCH/x86/i386}/*.so
}

pkg_postinst() {
	elog "This ebuild installs into /opt/${PN} and /usr/share/${PN}"
	elog 'To use you need to pass the following to java'
	elog '-Djava.library.path=$(java-config -i sun-java3d-bin) -cp $(java-config -p sun-java3d-bin)'
}
