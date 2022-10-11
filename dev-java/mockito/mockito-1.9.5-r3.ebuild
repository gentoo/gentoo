# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.mockito:mockito-core:1.9.5"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A mocking framework for Java"
HOMEPAGE="https://github.com/mockito/mockito"
SRC_URI="https://repo1.maven.org/maven2/org/mockito/mockito-core/${PV}/mockito-core-${PV}-sources.jar"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

CP_DEPEND="
	dev-java/ant-core:0
	dev-java/hamcrest-core:0
	dev-java/junit:4
	dev-java/objenesis:0
"
DEPEND=">=virtual/jdk-1.8:*
	${CP_DEPEND}"
RDEPEND=">=virtual/jre-1.8:*
	${CP_DEPEND}"
BDEPEND="app-arch/unzip"

JAVADOC_ARGS="-source 8"
