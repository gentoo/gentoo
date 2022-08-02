# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="jakarta.xml.ws:jakarta.xml.ws-api:2.3.3"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JAX-WS (JSR 224) API (Eclipse Project for JAX-WS)"
HOMEPAGE="https://github.com/eclipse-ee4j/jax-ws-api"
SRC_URI="https://github.com/eclipse-ee4j/jax-ws-api/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD" # "BSD-3 Clause"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND="
	dev-java/jakarta-xml-soap-api:1
	dev-java/jaxb-api:2
	>=virtual/jdk-11:*
"

DOCS=( ../{CONTRIBUTING,NOTICE,README}.md )

S="${WORKDIR}/jax-ws-api-${PV}/api"

JAVA_CLASSPATH_EXTRA="
	jakarta-xml-soap-api-1
	jaxb-api-2
"
JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"
