# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="jakarta.json.bind:jakarta.json.bind-api:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta JSON Binding"
HOMEPAGE="https://github.com/jakartaee/jsonb-api"
SRC_URI="https://github.com/jakartaee/jsonb-api/archive/${PV}-RELEASE.tar.gz -> ${P}-RELEASE.tar.gz"
S="${WORKDIR}/${P}-RELEASE"

LICENSE="EPL-2.0"
SLOT="0"
KEYWORDS="amd64"

CP_DEPEND="~dev-java/jsonp-api-2.0.2:0"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_SRC_DIR="api/src/main/java"
