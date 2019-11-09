# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2

MY_PV=${PV//./_}
DESCRIPTION="JAI is a class library for managing images"
HOMEPAGE="https://jai.dev.java.net/"
SRC_URI="http://download.java.net/media/jai/builds/release/${MY_PV}/jai-${MY_PV}-lib-linux-i586.tar.gz"

LICENSE="sun-bcla-jai"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=">=virtual/jre-1.3"

RESTRICT="bindist mirror"
QA_PREBUILT="*"

S=${WORKDIR}/jai-${MY_PV}

src_prepare() {
	default
	rm LICENSE-jai.txt || die
}

src_compile() { :; }

src_install() {
	dodoc *.txt

	java-pkg_dojar lib/*.jar
	use x86 && java-pkg_doso lib/*.so
}

pkg_postinst() {
	elog "This ebuild now installs into /opt/${PN} and /usr/share/${PN}"
	elog 'To use you need to pass the following to java'
	use x86 && elog '-Djava.library.path=$(java-config -i sun-jai-bin)'
	elog '-classpath $(java-config -p sun-jai-bin)'
}
