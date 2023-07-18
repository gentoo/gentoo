# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="source doc test"
MAVEN_ID="com.github.cliftonlabs:json-simple:2.3.1"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java 7+ toolkit to quickly develop RFC 4627 JSON compatible applications"
HOMEPAGE="https://www.json.org"
SRC_URI="https://github.com/cliftonlabs/json-simple/archive/json-simple-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="Apache-2.0"
SLOT="2.3"
KEYWORDS="amd64 ~arm64 ppc64 x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
