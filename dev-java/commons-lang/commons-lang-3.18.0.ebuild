# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# No tests, #839681
JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.apache.commons:commons-lang3:${PV}"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Commons components to manipulate core java classes"
HOMEPAGE="https://commons.apache.org/proper/commons-lang/"
SRC_URI="https://archive.apache.org/dist/commons/lang/source/${PN}3-${PV}-src.tar.gz -> ${P}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/commons/lang/source/${PN}3-${PV}-src.tar.gz.asc -> ${P}-src.tar.gz.asc )"
S="${WORKDIR}/${PN}3-${PV}-src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-solaris"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/commons.apache.org.asc"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"
DEPEND=">=virtual/jdk-11:*"	# module-info
RDEPEND=">=virtual/jre-1.8:*"

JAVA_AUTOMATIC_MODULE_NAME="org.apache.commons.lang3"
JAVA_INTERMEDIATE_JAR_NAME="org.apache.${PN/-/.}3"
JAVA_MODULE_INFO_OUT="src/main"
JAVA_SRC_DIR="src/main/java"
