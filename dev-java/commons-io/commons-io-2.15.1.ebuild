# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# No tests, #839681
JAVA_PKG_IUSE="doc source"
MAVEN_ID="commons-io:commons-io:${PV}"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Utility classes, stream implementations, file filters, and much more"
HOMEPAGE="https://commons.apache.org/proper/commons-io/"
SRC_URI="mirror://apache/commons/io/source/${P}-src.tar.gz
	verify-sig? ( https://archive.apache.org/dist/commons/io/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/${P}-src"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
RESTRICT="test" #839681

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/commons.apache.org.asc"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"
DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_AUTOMATIC_MODULE_NAME="org.apache.commons.io"
JAVA_ENCODING="iso-8859-1"
JAVA_SRC_DIR="src/main/java"
