# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java utility for computing and verifying checksums: CRC*, MD*, etc."
HOMEPAGE="http://www.jonelo.de/java/jacksum/"
SRC_URI="mirror://sourceforge/jacksum/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=virtual/jdk-1.3.1
	dev-java/ant-core
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.3.1"

S="${WORKDIR}"

src_unpack() {
	default
	unpack ./source/${PN}-src.zip
	rm *.jar || die
}

src_install() {
	java-pkg_dojar ${PN}.jar
	dodoc history.txt readme.txt help/${PN}/*

	java-pkg_dolauncher ${PN} --jar ${PN}.jar
}
