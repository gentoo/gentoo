# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This version provides module java.xml.soap and package javax.xml.soap
MAVEN_ID="jakarta.xml.soap:jakarta.xml.soap-api:1.4.2"

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="SOAP with Attachments API for Java (SAAJ) API (Eclipse Project for JAX-WS)"
HOMEPAGE="https://projects.eclipse.org/projects/ee4j.jaxws"
SRC_URI="https://github.com/eclipse-ee4j/saaj-api/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

# EDL-1.0 equivalent to BSD
# - 'SPDX-License-Identifier: BSD-3-Clause' in source files' headers
# - https://www.eclipse.org/org/documents/edl-v10.php
LICENSE="BSD"
# Since version 2.0.0, the namespace has changed to jakarta.xml.soap
SLOT="1"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

CP_DEPEND="
	dev-java/jakarta-activation-api:1
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

S="${WORKDIR}/saaj-api-${PV}"

JAVA_SRC_DIR="api/src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="api/src/test/java"
JAVA_TEST_RESOURCE_DIRS=( "api/src/test/resources" )

DOCS=( CONTRIBUTING.md NOTICE.md README.md )

src_test() {
	if ver_test "$(java-config -g PROVIDES_VERSION)" -lt 9; then
		# https://github.com/javaee/javax.xml.soap/blob/1.4.0/pom.xml#L134-L143
		JAVA_TEST_EXTRA_ARGS=( -Xbootclasspath/p:target/classes )
	else
		# '-Xbootclasspath/p' removed since JDK 9; '-Xbootclasspath/a' remains
		# https://openjdk.java.net/jeps/261
		JAVA_TEST_EXTRA_ARGS=( -Xbootclasspath/a:target/classes )
	fi
	java-pkg-simple_src_test
}

src_install() {
	java-pkg-simple_src_install
	einstalldocs # https://bugs.gentoo.org/789582
}
