# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple junit5

DESCRIPTION="Java HTML parser that makes sense of real-world HTML soup"
HOMEPAGE="https://jsoup.org/"
SRC_URI="https://github.com/jhy/jsoup/archive/refs/tags/${P}.tar.gz"
S="${WORKDIR}/jsoup-${P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# package io.netty.handler.codec.http.cookie does not exist
# package io.netty.handler.ssl does not exist
# package org.jsoup.integration.netty does not exist
RESTRICT="test"

BDEPENDS="app-arch/unzip"

DEPEND="
	>=virtual/jdk-1.8:*
	>=dev-java/jspecify-1.0.0:0
	>=dev-java/re2j-1.8:0
	test? (
		dev-java/gson:0
	)
"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_CLASSPATH_EXTRA="jspecify re2j"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="gson"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"
