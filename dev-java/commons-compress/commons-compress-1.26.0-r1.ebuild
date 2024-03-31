# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Not ready for running tests, https://bugs.gentoo.org/839681
JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.apache.commons:commons-compress:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Java API for working with archive files"
HOMEPAGE="https://commons.apache.org/proper/commons-compress/"
SRC_URI="mirror://apache/commons/compress/source/${P}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/commons/compress/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/${P}-src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/commons.apache.org.asc"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"
CP_DEPEND="
	dev-java/asm:9
	dev-java/brotli-dec:0
	dev-java/commons-codec:0
	>=dev-java/commons-io-2.15.1:1
	dev-java/commons-lang:3.6
	dev-java/xz-java:0
	dev-java/zstd-jni:0
"
DEPEND="${CP_DEPEND}
	>=virtual/jdk-11:*
	dev-java/osgi-core:0"
RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

JAVA_AUTOMATIC_MODULE_NAME="org.apache.commons.compress"
JAVA_CLASSPATH_EXTRA="osgi-core"
JAVA_ENCODING="iso-8859-1"
JAVA_MAIN_CLASS="org.apache.commons.compress.archivers.Lister"
JAVA_SRC_DIR="src/main/java"
