# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.bitstrings.test:junit-clptr:1.2.2"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="ClassLoader per Test runner for JUnit 4.12+"
HOMEPAGE="https://github.com/bitstrings/junit-clptr"
SRC_URI="https://github.com/bitstrings/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}-sources.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64"

CP_DEPEND="
	dev-java/junit:4
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
