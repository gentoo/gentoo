# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="jakarta.xml.rpc:jakarta.xml.rpc-api:1.1.4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Eclipse Project for Stable EE4J APIs"
HOMEPAGE="https://github.com/eclipse-ee4j/jax-rpc-api"
SRC_URI="https://github.com/eclipse-ee4j/jax-rpc-api/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="EPL-2.0 GPL-2-with-classpath-exception"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"

# Common dependencies
# POM: api/pom.xml
# jakarta.servlet:jakarta.servlet-api:4.0.3 -> >=dev-java/jakarta-servlet-api-4.0.4:4

CP_DEPEND="
	dev-java/jakarta-servlet-api:4
	dev-java/jakarta-xml-soap-api:1
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}"

JAVA_SRC_DIR="api/src/main/java"
