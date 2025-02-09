# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.codehaus.woodstox:stax2-api:4.2.1"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="stax2 API is an extension to basic Stax 1.0 API"
HOMEPAGE="https://github.com/FasterXML/stax2-api"
SRC_URI="https://github.com/FasterXML/${PN}/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

DEPEND=">=virtual/jdk-1.9:*"
RDEPEND=">=virtual/jre-1.8:*"

DOCS=( README.md release-notes/VERSION )

JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR=( "src/main/java" "src/moditect" )
