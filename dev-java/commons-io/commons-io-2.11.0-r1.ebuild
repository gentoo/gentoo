# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://mirror.dkm.cz/apache//commons/io/source/commons-io-2.11.0-src.tar.gz --slot 0 --keywords "~amd64 ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris" --ebuild commons-io-2.11.0.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="commons-io:commons-io:2.11.0"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Utility classes, stream implementations, file filters, and much more"
HOMEPAGE="https://commons.apache.org/proper/commons-io/"
SRC_URI="mirror://apache/commons/io/source/${P}-src.tar.gz -> ${P}-sources.tar.gz"
LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"

# Compile dependencies
# POM: pom.xml
# test? com.google.jimfs:jimfs:1.2 -> !!!groupId-not-found!!!
# test? org.apache.commons:commons-lang3:3.12.0 -> >=dev-java/commons-lang-3.12.0:3.6
# test? org.junit-pioneer:junit-pioneer:1.4.2 -> !!!groupId-not-found!!!
# test? org.junit.jupiter:junit-jupiter:5.7.2 -> !!!groupId-not-found!!!
# test? org.mockito:mockito-inline:3.11.2 -> !!!artifactId-not-found!!!
# test? org.openjdk.jmh:jmh-core:1.32 -> !!!groupId-not-found!!!
# test? org.openjdk.jmh:jmh-generator-annprocess:1.32 -> !!!groupId-not-found!!!

DEPEND="
	>=virtual/jdk-1.8:*
	test? (
		>=dev-java/commons-lang-3.12.0:3.6
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
"

# some test dependencies are missing
RESTRICT="test"

S="${WORKDIR}/${P}-src"

JAVA_ENCODING="iso-8859-1"

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="commons-lang-3.6"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_AUTOMATIC_MODULE_NAME="org.apache.commons.io"
