# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.opentest4j.reporting:open-test-reporting-events:0.1.0-M1"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Language-agnostic test reporting format and tooling"
HOMEPAGE="https://github.com/ota4j-team/open-test-reporting"
MY_PV="${PV/_pre/-M}"
SRC_URI="https://github.com/ota4j-team/open-test-reporting/archive/r${MY_PV}.tar.gz -> open-test-reporting-${MY_PV}.tar.gz"
S="${WORKDIR}/open-test-reporting-r${MY_PV}/events"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

CP_DEPEND="~dev-java/open-test-reporting-schema-${PV}:0"
RDEPEND=">=virtual/jre-1.8:*
	${CP_DEPEND}"
DEPEND=">=virtual/jdk-1.8:*
	${CP_DEPEND}"

JAVA_SRC_DIR="src/main/java"
JAVA_AUTOMATIC_MODULE_NAME="org.opentest4j.reporting.events"
