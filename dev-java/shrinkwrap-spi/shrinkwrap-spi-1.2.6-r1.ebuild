# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.jboss.shrinkwrap:shrinkwrap-spi:1.2.6"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Generic Service Provider Contract of the ShrinkWrap Project"
HOMEPAGE="https://arquillian.org/modules/shrinkwrap-shrinkwrap/"
SRC_URI="https://github.com/shrinkwrap/shrinkwrap/archive/${PV}.tar.gz -> shrinkwrap-${PV}.tar.gz"
S="${WORKDIR}/shrinkwrap-${PV}/spi"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

CP_DEPEND="~dev-java/shrinkwrap-api-${PV}:0"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_SRC_DIR="src/main/java"
