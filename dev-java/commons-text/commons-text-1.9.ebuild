# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://downloads.apache.org//commons/text/source/commons-text-1.9-src.tar.gz --slot 0 --keywords "~amd64 ~x86" --ebuild commons-text-1.9.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.apache.commons:commons-text:1.9"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Apache Commons Text is a library focused on algorithms working on strings."
HOMEPAGE="https://commons.apache.org/proper/commons-text"
SRC_URI="https://downloads.apache.org//commons/text/source/${P}-src.tar.gz -> ${P}-sources.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Common dependencies
# POM: pom.xml
# org.apache.commons:commons-lang3:3.11 -> >=dev-java/commons-lang-3.11:3.6

CDEPEND="
	>=dev-java/commons-lang-3.11:3.6
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}"

S="${WORKDIR}/${P}-src"

JAVA_ENCODING="ISO-8859-1"

JAVA_GENTOO_CLASSPATH="commons-lang-3.6"
JAVA_SRC_DIR="src/main/java"
