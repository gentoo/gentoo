# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://mirrors.supportex.net/apache//commons/compress/source/commons-compress-1.20-src.tar.gz --slot 0 --keywords "~amd64 ~x86" --ebuild commons-compress-1.20.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.apache.commons:commons-compress:1.20"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java API for working with archive files"
HOMEPAGE="https://commons.apache.org/proper/commons-compress/"
SRC_URI="https://mirrors.supportex.net/apache//commons/compress/source/${P}-src.tar.gz -> ${P}-sources.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

CDEPEND="
	dev-java/brotli-dec:0
	dev-java/xz-java:0
	dev-java/zstd-jni:0
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}"

S="${WORKDIR}/${P}-src"

JAVA_ENCODING="iso-8859-1"

JAVA_GENTOO_CLASSPATH="brotli-dec,xz-java,zstd-jni"
JAVA_SRC_DIR="src/main/java"
