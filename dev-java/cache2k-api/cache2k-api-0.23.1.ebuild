# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.cache2k:cache2k-api:0.23.1"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="light weight and high performance Java caching library: API"
HOMEPAGE="https://cache2k.org"
SRC_URI="https://github.com/cache2k/cache2k/archive/v${PV}.tar.gz -> cache2k-${PV}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}/cache2k-${PV}/api"

JAVA_SRC_DIR="src/main/java"
