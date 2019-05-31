# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Hash of tag, download not available via ${PV}
MY_PN="jmh"
MY_PV="f25ae8584db1"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Harness for building, running, and analysing nano/micro/milli/macro benchmarks"
HOMEPAGE="https://openjdk.java.net/projects/code-tools/jmh"
SRC_URI="https://hg.openjdk.java.net/code-tools/${MY_PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# jopt *must* be 4.6, see https://mail.openjdk.java.net/pipermail/jmh-dev/2016-October/002395.html
CP_DEPEND="
	dev-java/asm:4
	dev-java/junit:4
	dev-java/commons-math:3
	dev-java/jopt-simple:4.6"

DEPEND=">=virtual/jdk-1.7
	${CP_DEPEND}"

RDEPEND=">=virtual/jre-1.7
	${CP_DEPEND}"

S="${WORKDIR}/${MY_PN}-${MY_PV}/${PN}"
