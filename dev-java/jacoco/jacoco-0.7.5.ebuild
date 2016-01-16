# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=5
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DATE="201505241946"

DESCRIPTION="Java Code Coverage library."
HOMEPAGE="http://eclemma.org/jacoco/"
SRC_URI="
	https://repo1.maven.org/maven2/org/${PN}/org.${PN}.report/${PV}.${DATE}/org.${PN}.report-${PV}.${DATE}-sources.jar -> ${P}-report.jar
	https://repo1.maven.org/maven2/org/${PN}/org.${PN}.agent/${PV}.${DATE}/org.${PN}.agent-${PV}.${DATE}-sources.jar -> ${P}-agent.jar
	https://repo1.maven.org/maven2/org/${PN}/org.${PN}.core/${PV}.${DATE}/org.${PN}.core-${PV}.${DATE}-sources.jar -> ${P}-core.jar
	https://repo1.maven.org/maven2/org/${PN}/org.${PN}.ant/${PV}.${DATE}/org.${PN}.ant-${PV}.${DATE}-sources.jar -> ${P}-ant.jar"
LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

CDEPEND="
	dev-java/ant-core:0
	dev-java/asm:4"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	app-arch/unzip
	>=virtual/jdk-1.6"

JAVA_GENTOO_CLASSPATH="
	asm-4
	ant-core
"
