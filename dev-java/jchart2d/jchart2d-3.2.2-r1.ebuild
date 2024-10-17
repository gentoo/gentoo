# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="net.sf.jchart2d:jchart2d:3.2.2"
# JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A minimalistic realtime charting library for Java"
HOMEPAGE="http://jchart2d.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/project/jchart2d/jchart2d/sources/jchart2d-eclipse-project-${PV}.zip"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="dev-java/jide-oss:0
	dev-java/xmlgraphics-commons:2"

DEPEND=">=virtual/jdk-1.8:*
	${CP_DEPEND}"

RDEPEND=">=virtual/jre-1.8:*
	${CP_DEPEND}"

BDEPEND="
	app-arch/unzip"

S="${WORKDIR}/${PN}"

DOCS=( ../NOTICE-apache-xmlgraphics-commons )

JAVA_SRC_DIR="src"

# FAILURES!!!
# Tests run: 212,  Failures: 119
# JAVA_TEST_SRC_DIR="test"
# JAVA_TEST_GENTOO_CLASSPATH="junit-4"

src_prepare() {
	default
	java-pkg_clean

	# src/Bug3553696.java:3: error: package info.monitorenter.gui.chart.tracepoints does not exist
	# import info.monitorenter.gui.chart.tracepoints.TracePoint2D;
	#                                               ^
	rm src/Bug3553696.java || die
}

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
