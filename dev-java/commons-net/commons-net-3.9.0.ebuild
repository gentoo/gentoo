# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc examples source"
MAVEN_ID="commons-net:commons-net:3.9.0"
# No tests, junit-jupiter and junit-vintage are not packaged.
# JAVA_TESTING_FRAMEWORKS="junit-vintage junit-jupiter"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Client-oriented Java library to implement many Internet protocols"
HOMEPAGE="https://commons.apache.org/proper/commons-net/"
SRC_URI="mirror://apache/commons/net/source/commons-net-${PV}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/commons/net/source/commons-net-${PV}-src.tar.gz.asc )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}/usr/share/openpgp-keys/commons.apache.org.asc"

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
