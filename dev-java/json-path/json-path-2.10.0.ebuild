# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.jayway.jsonpath:json-path:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java JsonPath implementation "
HOMEPAGE="https://github.com/json-path/JsonPath"
SRC_URI="https://github.com/json-path/JsonPath/archive/${P}.tar.gz"
S="${WORKDIR}/JsonPath-${P}/json-path"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="
	dev-java/tapestry-json:0
	dev-java/gson:0
	>=dev-java/jackson-databind-2.20.0:0
	dev-java/jettison:0
	dev-java/json:0
	dev-java/jsonb-api:0
	dev-java/jsonp-api:0
	>=dev-java/json-smart-2.5.2:0
	dev-java/slf4j-api:0
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
"

RDEPEND="
	${CP_DEPEND}
	>=dev-java/jackson-core-2.20.0:0
	>=virtual/jre-1.8:*
"

JAVA_AUTOMATIC_MODULE_NAME="json.path"
JAVA_SRC_DIR="src/main/java"

src_install() {
	java-pkg-simple_src_install
	java-pkg_register-dependency jackson-core
}
