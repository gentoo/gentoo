# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.openjdk.jmh:jmh-generator-annprocess:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Harness for building, running, and analysing nano/micro/milli/macro benchmarks"
HOMEPAGE="https://openjdk.org/projects/code-tools/jmh/"
SRC_URI="https://github.com/openjdk/jmh/archive/${PV}.tar.gz -> jmh-${PV}.tar.gz"
S="${WORKDIR}/jmh-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND="
	dev-java/jmh-core:0
	>=virtual/jdk-1.8:*
"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_CLASSPATH_EXTRA="jmh-core"
JAVA_RESOURCE_DIRS="jmh-generator-annprocess/src/main/resources"
JAVA_SRC_DIR="jmh-generator-annprocess/src/main/java"
