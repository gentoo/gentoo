# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.github.donpark.identicon:identicon:1.0"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Visual representation of a hash value"
HOMEPAGE="https://github.com/PauloMigAlmeida/identicon"
COMMIT="96902d3c7c9733d9da4cce9c5ed424557fc2ec3c"
SRC_URI="https://github.com/PauloMigAlmeida/identicon/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="1"
KEYWORDS="amd64 ~arm64 ~x86"

CP_DEPEND="
	dev-java/cache2k-api:0
	dev-java/commons-logging:0
"
DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
"
RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

S="${WORKDIR}/${PN}-${COMMIT}/core"

JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="cache2k-api-2"
