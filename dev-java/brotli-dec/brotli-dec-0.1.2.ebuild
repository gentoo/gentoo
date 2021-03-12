# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.brotli:dec:0.1.2"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Brotli decompressor"
HOMEPAGE="https://github.com/google/brotli"
SRC_URI="https://repo1.maven.org/maven2/org/brotli/dec/0.1.2/dec-0.1.2-sources.jar -> ${P}-sources.jar"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"
DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"
