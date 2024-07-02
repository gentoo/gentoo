# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.apache.commons:commons-text:${PV}"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Apache Commons Text is a library focused on algorithms working on strings"
HOMEPAGE="https://commons.apache.org/proper/commons-text/"
SRC_URI="mirror://apache//commons/text/source/${P}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/commons/text/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/${P}-src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/commons.apache.org.asc"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"
CP_DEPEND="dev-java/commons-lang:3.6"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DOCS=( CONTRIBUTING.md NOTICE.txt README.md RELEASE-NOTES.txt )

JAVA_AUTOMATIC_MODULE_NAME="org.apache.commons.text"
JAVA_ENCODING="ISO-8859-1"
JAVA_SRC_DIR="src/main/java"
