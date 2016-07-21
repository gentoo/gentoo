# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java runtime metadata analysis"
HOMEPAGE="https://github.com/ronmamo/reflections"
SRC_URI="http://search.maven.org/remotecontent?filepath=org/${PN}/${PN}/${PV}/${P}-sources.jar"
LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND="dev-java/commons-vfs:2
	dev-java/dom4j:1
	dev-java/gson:2.6
	dev-java/guava:18
	dev-java/javassist:3
	dev-java/jsr305:0
	dev-java/slf4j-api:0
	dev-java/tomcat-servlet-api:3.1"

RDEPEND=">=virtual/jre-1.7
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.7
	${CDEPEND}
	app-arch/unzip"

JAVA_GENTOO_CLASSPATH="commons-vfs-2,dom4j-1,gson-2.6,guava-18,javassist-3,jsr305,slf4j-api,tomcat-servlet-api-3.1"
