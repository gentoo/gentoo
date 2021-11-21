# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java runtime metadata analysis"
HOMEPAGE="https://github.com/ronmamo/reflections"
SRC_URI="http://search.maven.org/remotecontent?filepath=org/${PN}/${PN}/${PV}/${P}-sources.jar"
LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"

CP_DEPEND="dev-java/commons-vfs:2
	dev-java/dom4j:1
	dev-java/gson:2.6
	dev-java/guava:20
	dev-java/javassist:3
	dev-java/jsr305:0
	dev-java/slf4j-api:0
	dev-java/tomcat-servlet-api:3.1"

RDEPEND=">=virtual/jre-1.7
	${CP_DEPEND}"

DEPEND=">=virtual/jdk-1.7
	${CP_DEPEND}
	app-arch/unzip"
