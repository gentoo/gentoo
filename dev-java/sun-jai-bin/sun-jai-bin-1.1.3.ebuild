# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit java-pkg-2

MY_PV=${PV//./_}
DESCRIPTION="JAI is a class library for managing images"
HOMEPAGE="https://jai.dev.java.net/"
SRC_URI="http://download.java.net/media/jai/builds/release/${MY_PV}/jai-${MY_PV}-lib-linux-i586.tar.gz"
LICENSE="sun-bcla-jai"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"
DEPEND="app-arch/unzip"
RDEPEND=">=virtual/jre-1.3"
IUSE=""
RESTRICT="mirror"
QA_PREBUILT="*"

S=${WORKDIR}/jai-${MY_PV}/

src_unpack() {
	unpack ${A}
	rm "${S}"/LICENSE-jai.txt
}

src_compile() { :; }

src_install() {
	dodoc *.txt

	cd lib
	java-pkg_dojar *.jar
	use x86 && java-pkg_doso *.so
}

pkg_postinst() {
	elog "This ebuild now installs into /opt/${PN} and /usr/share/${PN}"
	elog 'To use you need to pass the following to java'
	use x86 && elog '-Djava.library.path=$(java-config -i sun-jai-bin)'
	elog '-classpath $(java-config -p sun-jai-bin)'
}
