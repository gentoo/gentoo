# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="examples doc source"

inherit base java-pkg-2 java-ant-2

DESCRIPTION="Commons-launcher eliminates the need for a batch or shell script to launch a Java class"
HOMEPAGE="http://commons.apache.org/launcher/"
SRC_URI="mirror://apache/jakarta/${PN/-//}/source/${P}-src.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 x86 ~x86-fbsd"
IUSE=""

DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4
	dev-java/ant-core"

S=${WORKDIR}/${PN}

# https://issues.apache.org/jira/browse/LAUNCHER-7
PATCHES=( "${FILESDIR}/1.1-javadoc.patch" )

src_compile() {
	java-ant_rewrite-classpath "${S}/build.xml"
	EANT_GENTOO_CLASSPATH="ant-core" java-pkg-2_src_compile
}

# Standard commons build.xml but no tests actually implemented
src_test() { :; }

src_install() {
	java-pkg_dojar dist/bin/*.jar || die "java-pkg_dojar died"
	dodoc README.txt NOTICE.txt || die
	use doc && java-pkg_dojavadoc dist/docs/api
	use examples && java-pkg_doexamples example
	use source && java-pkg_dosrc src/java/*
}
