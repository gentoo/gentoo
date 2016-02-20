# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PN="apache-${PN}"

DESCRIPTION="Apache Rat is a release audit tool, focused on licenses."
HOMEPAGE="https://creadur.apache.org/rat/"

SRC_URI="
	https://repo1.maven.org/maven2/org/apache/${PN}/${MY_PN}-core/${PV}/${MY_PN}-core-${PV}-sources.jar
	https://repo1.maven.org/maven2/org/apache/${PN}/${MY_PN}-tasks/${PV}/${MY_PN}-tasks-${PV}-sources.jar"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

CDEPEND="
	dev-java/ant-core:0
	dev-java/commons-io:1
	dev-java/commons-cli:1
	dev-java/commons-lang:2.1
	dev-java/commons-compress:0
	dev-java/commons-collections:0
"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	app-arch/unzip
	>=virtual/jdk-1.6"

JAVA_GENTOO_CLASSPATH="
	ant-core
	commons-io-1
	commons-cli-1
	commons-compress
	commons-lang-2.1
	commons-collections
"

src_install() {
	java-pkg-simple_src_install
	java-pkg_dolauncher "${MY_PN}" --main org.apache.rat.Report
}
