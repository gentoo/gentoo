# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri mirror://apache//commons/text/source/commons-text-1.10.0-src.tar.gz --slot 0 --keywords "~amd64 ~ppc64 ~x86" --ebuild commons-text-1.10.0.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.apache.commons:commons-text:1.10.0"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Apache Commons Text is a library focused on algorithms working on strings"
HOMEPAGE="https://commons.apache.org/proper/commons-text/"
SRC_URI="mirror://apache//commons/text/source/commons-text-${PV}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"

# Common dependencies
# POM: pom.xml
# org.apache.commons:commons-lang3:3.12.0 -> >=dev-java/commons-lang-3.12.0:3.6

CDEPEND="
	dev-java/commons-lang:3.6
"

# Compile dependencies
# POM: pom.xml
# test? commons-io:commons-io:2.11.0 -> >=dev-java/commons-io-2.11.0:1
# test? org.apache.commons:commons-rng-simple:1.4 -> !!!artifactId-not-found!!!
# test? org.assertj:assertj-core:3.23.1 -> !!!suitable-mavenVersion-not-found!!!
# test? org.graalvm.js:js:22.0.0.2 -> !!!groupId-not-found!!!
# test? org.graalvm.js:js-scriptengine:22.0.0.2 -> !!!groupId-not-found!!!
# test? org.junit.jupiter:junit-jupiter:5.9.1 -> !!!groupId-not-found!!!
# test? org.mockito:mockito-inline:4.8.0 -> !!!artifactId-not-found!!!
# test? org.openjdk.jmh:jmh-core:1.35 -> >=dev-java/jmh-core-1.35:0
# test? org.openjdk.jmh:jmh-generator-annprocess:1.35 -> !!!artifactId-not-found!!!

DEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}"

DOCS=( CONTRIBUTING.md NOTICE.txt README.md RELEASE-NOTES.txt )

S="${WORKDIR}/${P}-src"

JAVA_AUTOMATIC_MODULE_NAME="org.apache.commons.text"
JAVA_ENCODING="ISO-8859-1"

JAVA_GENTOO_CLASSPATH="commons-lang-3.6"
JAVA_SRC_DIR="src/main/java"
