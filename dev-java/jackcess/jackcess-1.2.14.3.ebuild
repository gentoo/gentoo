# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Pure Java library for reading from and writing to MS Access databases"
HOMEPAGE="http://jackcess.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-sources.jar"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

CP_DEPEND=">=dev-java/commons-lang-2.6:2.1
	>=dev-java/commons-logging-1.1.3:0
	>=dev-java/log4j-1.2.7:0"

DEPEND=">=virtual/jdk-1.7
	app-arch/unzip
	${CP_DEPEND}"

RDEPEND=">=virtual/jre-1.7
	${CP_DEPEND}"

src_compile() {
	java-pkg-simple_src_compile
	java-pkg_addres "${PN}.jar" .
}
