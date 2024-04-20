# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.typesafe:config:1.4.2"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A library of arguably useful Java utilities"
HOMEPAGE="https://lightbend.github.io/config/"
SRC_URI="https://github.com/lightbend/config/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"
IUSE="doc source"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*"

DOCS=( {CONTRIBUTING,HOCON,NEWS,README}.md )

S="${WORKDIR}/config-${PV}"

JAVA_SRC_DIR="config/src/main/java"
# https://github.com/lightbend/config/blob/v1.4.2/build.sbt#L104
JAVA_AUTOMATIC_MODULE_NAME="typesafe.config"

# Need to anylyze what to do with this stuff
JAVA_TEST_SRC_DIR="config/src/test/java"
JAVA_TEST_RESOURCE_DIRS="config/src/test/resources"
