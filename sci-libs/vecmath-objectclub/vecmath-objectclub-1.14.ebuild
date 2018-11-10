# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit java-pkg-2

MY_PN="${PN/-objectclub/1.2}"

DESCRIPTION="Unofficial free implementation of Sun javax.vecmath by Kenji Hiranabe"
HOMEPAGE="http://www.objectclub.jp/download/vecmath_e"
SRC_URI="http://www.objectclub.jp/download/files/vecmath/${MY_PN}-${PV}.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	mkdir classes
}

src_compile() {
	find javax/ -name "*.java" > "${T}/src.list"
	ejavac -d "${S}/classes" "@${T}/src.list"

	cd classes
	jar -cf "${S}"/${PN}.jar * || die "failed to create jar"
}

src_install() {
	java-pkg_dojar ${PN}.jar
	dodoc README
}
