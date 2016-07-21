# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit java-pkg-2

MY_PV=${PV//./_}
DESCRIPTION="JAI is a class library for managing images"
HOMEPAGE="https://jai.dev.java.net/"

BASE=http://download.java.net/media/jai/builds/release/${MY_PV}
MY_P="jai-${MY_PV}"
SRC_URI="
	!amd64? ( ${BASE}/${MY_P}-lib-linux-i586.tar.gz )
	amd64? ( ${BASE}/${MY_P}-lib-linux-amd64.tar.gz )"

LICENSE="sun-bcla-jai"
SLOT="0"
KEYWORDS="amd64"
DEPEND=""
RDEPEND=">=virtual/jre-1.3"
IUSE=""
RESTRICT="mirror"
QA_PREBUILT="*"

S=${WORKDIR}/${MY_P}/

src_unpack() {
	unpack ${A}
	rm "${S}/LICENSE-jai.txt"
}

src_compile() { :; }

src_install() {
	dodoc *.txt || die

	cd lib
	java-pkg_dojar *.jar
	use x86 && java-pkg_doso *.so
	use amd64 && java-pkg_doso *.so
}

pkg_postinst() {
	elog "This ebuild now installs into /opt/${PN} and /usr/share/${PN}"
	elog 'To use you need to pass the following to java'
	if use x86 || use amd64; then
		elog '-Djava.library.path=$(java-config -i sun-jai-bin)'
	fi
	elog '-classpath $(java-config -p sun-jai-bin)'
}
