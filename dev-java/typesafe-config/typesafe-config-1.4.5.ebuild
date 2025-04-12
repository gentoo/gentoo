# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# No tests, all written in scala.
JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.typesafe:config:1.4.4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A library of arguably useful Java utilities"
HOMEPAGE="https://lightbend.github.io/config/"
SRC_URI="https://github.com/lightbend/config/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/config-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*"

DOCS=( {CONTRIBUTING,HOCON,NEWS,README}.md )

# https://github.com/lightbend/config/blob/v1.4.2/build.sbt#L104
JAVA_AUTOMATIC_MODULE_NAME="typesafe.config"
JAVA_SRC_DIR="config/src/main/java"
