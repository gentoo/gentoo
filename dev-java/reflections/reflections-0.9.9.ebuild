# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/reflections/reflections-0.9.9.ebuild,v 1.1 2015/03/19 23:25:25 chewi Exp $

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java runtime metadata analysis"
HOMEPAGE="http://code.google.com/p/reflections/"
SRC_URI="http://search.maven.org/remotecontent?filepath=org/${PN}/${PN}/${PV}/${P}-sources.jar"
LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

CDEPEND="dev-java/commons-vfs:2
	dev-java/dom4j:1
	dev-java/gson:2.2.2
	dev-java/guava:18
	dev-java/javassist:3
	dev-java/jsr305:0
	dev-java/slf4j-api:0
	dev-java/tomcat-servlet-api:3.1"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.6
	${CDEPEND}
	app-arch/unzip"

JAVA_GENTOO_CLASSPATH="commons-vfs-2,dom4j-1,gson-2.2.2,guava-18,javassist-3,jsr305,slf4j-api,tomcat-servlet-api-3.1"
