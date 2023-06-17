# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"
MAVEN_ID="jakarta.xml.soap:jakarta.xml.soap-api:1.4.2"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="SOAP with Attachments API for Java (SAAJ) API (Eclipse Project for JAX-WS)"
HOMEPAGE="https://projects.eclipse.org/projects/ee4j.jaxws"
SRC_URI="https://github.com/jakartaee/saaj-api/archive/${PV}.tar.gz -> ${P}.tar.gz"

# EDL-1.0 equivalent to BSD
# - 'SPDX-License-Identifier: BSD-3-Clause' in source files' headers
# - https://www.eclipse.org/org/documents/edl-v10.php
LICENSE="BSD"
# Since version 2.0.0, the namespace has changed to jakarta.xml.soap
SLOT="1"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

CP_DEPEND="
	>=dev-java/jakarta-activation-api-1.2.2-r1:1
"

DEPEND="
	>=virtual/jdk-11:*
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
JAVA_TEST_EXTRA_ARGS=( -Xbootclasspath/a:target/classes )

DOCS=( CONTRIBUTING.md NOTICE.md README.md )

src_install() {
	java-pkg-simple_src_install
	einstalldocs # https://bugs.gentoo.org/789582
}
