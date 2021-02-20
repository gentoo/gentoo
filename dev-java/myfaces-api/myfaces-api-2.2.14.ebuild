# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Apache MyFaces API - Core package"
HOMEPAGE="https://myfaces.apache.org/"
SRC_URI="https://repo1.maven.org/maven2/org/apache/myfaces/core/${PN}/${PV}/${P}-sources.jar"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND="
	dev-java/cdi-api:1.2
	dev-java/javax-inject:0
	dev-java/tomcat-jstl-spec:0
	dev-java/validation-api:1.0
	dev-java/tomcat-servlet-api:3.0
	dev-java/myfaces-builder-annotations:0
	"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.8"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.8
	app-arch/unzip"

JAVA_GENTOO_CLASSPATH="
	cdi-api-1.2
	javax-inject
	tomcat-jstl-spec
	validation-api-1.0
	tomcat-servlet-api-3.0
	myfaces-builder-annotations
"
