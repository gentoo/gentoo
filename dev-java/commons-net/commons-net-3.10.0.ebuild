# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# No tests because of missing eclass support of junit-jupiter, #902723
JAVA_PKG_IUSE="doc examples source"
MAVEN_ID="commons-net:commons-net:${PV}"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Client-oriented Java library to implement many Internet protocols"
HOMEPAGE="https://commons.apache.org/proper/commons-net/"
SRC_URI="mirror://apache/commons/net/source/commons-net-${PV}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/commons/net/source/commons-net-${PV}-src.tar.gz.asc )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/commons.apache.org.asc"

DOCS=(
	CONTRIBUTING.md
	NOTICE.txt
	README.md
	RELEASE-NOTES.txt
)

S="${WORKDIR}/${P}-src"

JAVA_AUTOMATIC_MODULE_NAME="org.apache.commons.net"
JAVA_ENCODING="iso-8859-1"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
