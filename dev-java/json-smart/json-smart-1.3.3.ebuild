# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="net.minidev:json-smart:1.3.3"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="old JSON parser"
HOMEPAGE="https://urielch.github.io"
SRC_URI="https://github.com/netplex/json-smart-v1/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="amd64 ~arm ~arm64 ~x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}/${PN}-v1-${PV}/json-smart"

JAVA_SRC_DIR="src/main/java"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
