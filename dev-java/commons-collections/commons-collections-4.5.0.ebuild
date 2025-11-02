# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# No tests, #839681
JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.apache.commons:commons-collections4:${PV}"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Extends the JCF classes with new interfaces, implementations and utilities"
HOMEPAGE="https://commons.apache.org/proper/commons-collections/"
SRC_URI="mirror://apache/commons/collections/source/${PN}4-${PV}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/commons/collections/source/${PN}4-${PV}-src.tar.gz.asc )"
S="${WORKDIR}/commons-collections4-${PV}-src"

LICENSE="Apache-2.0"
SLOT="4"
KEYWORDS="amd64 arm64 ppc64"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/commons.apache.org.asc"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"

# At least java 11 for module-info. Compilation errors with java 21 or higher.
# https://bugs.gentoo.org/916445 https://issues.apache.org/jira/browse/COLLECTIONS-842
DEPEND="|| ( virtual/jdk:17 virtual/jdk:11 )"
RDEPEND=">=virtual/jre-1.8:*"

DOCS=( {CONTRIBUTING,README}.md {NOTICE,RELEASE-NOTES}.txt )
HTML_DOCS=( {DEVELOPERS-GUIDE,PROPOSAL}.html )

JAVA_AUTOMATIC_MODULE_NAME="org.apache.commons.collections4"
JAVA_INTERMEDIATE_JAR_NAME="org.apache.${PN/-/.}4"
JAVA_MODULE_INFO_OUT="src/main"
JAVA_SRC_DIR="src/main/java"
