# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

# Hash of tag, download not available via ${PV}
MY_PN="jmh"
MY_PV="7ff584954008"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Harness for building, running, and analysing nano/micro/milli/macro benchmarks"
HOMEPAGE="http://openjdk.java.net/projects/code-tools/jmh"
SRC_URI="http://hg.openjdk.java.net/code-tools/${MY_PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# jopt *must* be 4.6, see http://mail.openjdk.java.net/pipermail/jmh-dev/2016-October/002395.html
CDEPEND="
	dev-java/asm:4
	dev-java/commons-math:3
	=dev-java/jopt-simple-4.6:0
	dev-java/junit:4
	source? ( app-arch/zip )
"

DEPEND=">=virtual/jdk-1.7
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.7
	${CDEPEND}"

JAVA_GENTOO_CLASSPATH="asm-4,commons-math-3,jopt-simple,junit-4"

S="${WORKDIR}/${MY_PN}-${MY_PV}/${PN}"
