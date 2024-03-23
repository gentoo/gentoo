# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# No tests because of missing eclass support of junit-jupiter, #902723
JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.apache.commons:commons-lang3:${PV}"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Commons components to manipulate core java classes"
HOMEPAGE="https://commons.apache.org/proper/commons-lang/"
SRC_URI="https://archive.apache.org/dist/commons/lang/source/${PN}3-${PV}-src.tar.gz -> ${P}-src.tar.gz
	verify-sig? ( https://archive.apache.org/dist/commons/lang/source/${PN}3-${PV}-src.tar.gz.asc -> ${P}-src.tar.gz.asc )"
S="${WORKDIR}/${PN}3-${PV}-src"

LICENSE="Apache-2.0"
SLOT="3.6"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-solaris"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/commons.apache.org.asc"

JAVA_AUTOMATIC_MODULE_NAME="org.apache.commons.lang3"
JAVA_ENCODING="ISO-8859-1"
JAVA_SRC_DIR="src/main/java"
