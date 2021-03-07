# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java Code Coverage library"
HOMEPAGE="https://eclemma.org/jacoco/"

SRC_URI="
	https://repo1.maven.org/maven2/org/${PN}/org.${PN}.report/${PV}/org.${PN}.report-${PV}-sources.jar -> ${P}-report.jar
	https://repo1.maven.org/maven2/org/${PN}/org.${PN}.agent/${PV}/org.${PN}.agent-${PV}-sources.jar -> ${P}-agent.jar
	https://repo1.maven.org/maven2/org/${PN}/org.${PN}.core/${PV}/org.${PN}.core-${PV}-sources.jar -> ${P}-core.jar
	https://repo1.maven.org/maven2/org/${PN}/org.${PN}.ant/${PV}/org.${PN}.ant-${PV}-sources.jar -> ${P}-ant.jar"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"

CDEPEND="
	dev-java/ant-core:0
	dev-java/asm:4"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

JAVA_GENTOO_CLASSPATH="
	asm-4
	ant-core
"
