# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.minidns:minidns-core:1.0.4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="DNS library for Java and Android systems"
HOMEPAGE="https://github.com/minidns/minidns"
SRC_URI="https://github.com/MiniDNS/minidns/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="amd64 ~arm ~arm64 ~x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}/minidns-${PV}/${PN}"

JAVA_SRC_DIR="src/main/java"
# needs junit:5
#JAVA_TESTING_FRAMEWORKS="junit-5"
#JAVA_TEST_SRC_DIR="src/test/java"
#JAVA_TEST_RESOURCE_DIRS="src/test/resources"
