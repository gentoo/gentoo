# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

MY_PV=${PV//./_}
DESCRIPTION="JAI is a class library for managing images"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"

BASE=https://download.java.net/media/jai/builds/release/${MY_PV}
MY_P="jai-${MY_PV}"
SRC_URI="
	!amd64? ( ${BASE}/${MY_P}-lib-linux-i586.tar.gz )
	amd64? ( ${BASE}/${MY_P}-lib-linux-amd64.tar.gz )"

S=${WORKDIR}/${MY_P}

LICENSE="sun-bcla-jai"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

RDEPEND="virtual/jre:1.8"

RESTRICT="bindist mirror"
QA_PREBUILT="*"

src_prepare() {
	java-pkg-2_src_prepare
	rm LICENSE-jai.txt || die
}

src_compile() { :; }

src_install() {
	dodoc *.txt

	java-pkg_dojar lib/*.jar
	use x86 && java-pkg_doso lib/*.so
	use amd64 && java-pkg_doso lib/*.so
}

pkg_postinst() {
	elog "This ebuild now installs into /opt/${PN} and /usr/share/${PN}"
	elog 'To use you need to pass the following to java'
	if use x86 || use amd64; then
		elog '-Djava.library.path=$(java-config -i sun-jai-bin)'
	fi
	elog '-classpath $(java-config -p sun-jai-bin)'
}
