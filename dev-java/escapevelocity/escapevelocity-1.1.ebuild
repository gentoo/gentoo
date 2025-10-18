# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A reimplementation of a subset of the Apache Velocity templating system."
HOMEPAGE="https://github.com/google/escapevelocity"
SRC_URI="https://github.com/google/${PN}/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64"

CP_DEPEND=">=dev-java/guava-33.4.8:0"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
	test? (
		>=dev-java/guava-testlib-33.4.8:0
		dev-java/velocity:0
		dev-java/truth:0
	)
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="guava-testlib,junit-4,truth,velocity"
JAVA_TEST_SRC_DIR="src/test/java"
