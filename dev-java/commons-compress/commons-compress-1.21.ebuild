# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://apache.miloslavbrada.cz//commons/compress/source/commons-compress-1.21-src.tar.gz --slot 0 --keywords "~amd64 ~arm64 ~x86" --ebuild commons-compress-1.21.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.apache.commons:commons-compress:1.21"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java API for working with archive files"
HOMEPAGE="https://commons.apache.org/proper/commons-compress/"
SRC_URI="mirror://apache/commons/compress/source/${P}-src.tar.gz -> ${P}-sources.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"

# Common dependencies
# POM: pom.xml
# asm:asm:3.2 -> !!!groupId-not-found!!!
# com.github.luben:zstd-jni:1.5.0-2 -> >=dev-java/zstd-jni-1.5.0.4:0
# org.brotli:dec:0.1.2 -> >=dev-java/brotli-dec-0.1.2:0
# org.tukaani:xz:1.9 -> >=dev-java/xz-java-1.9:0

CDEPEND="
	dev-java/asm:9
	>=dev-java/brotli-dec-0.1.2:0
	>=dev-java/xz-java-1.9:0
	>=dev-java/zstd-jni-1.5.0.4:0
"

# Compile dependencies
# POM: pom.xml
# org.osgi:org.osgi.core:6.0.0 -> !!!artifactId-not-found!!!
# POM: pom.xml
# test? com.github.marschall:memoryfilesystem:2.1.0 -> !!!groupId-not-found!!!
# test? javax.inject:javax.inject:1 -> !!!groupId-not-found!!!
# test? junit:junit:4.13.2 -> >=dev-java/junit-4.13.2:4
# test? org.apache.felix:org.apache.felix.framework:7.0.0 -> !!!groupId-not-found!!!
# test? org.hamcrest:hamcrest:2.2 -> !!!artifactId-not-found!!!
# test? org.mockito:mockito-core:3.11.1 -> !!!suitable-mavenVersion-not-found!!!
# test? org.ops4j.pax.exam:pax-exam-cm:4.13.1 -> !!!groupId-not-found!!!
# test? org.ops4j.pax.exam:pax-exam-container-native:4.13.1 -> !!!groupId-not-found!!!
# test? org.ops4j.pax.exam:pax-exam-junit4:4.13.1 -> !!!groupId-not-found!!!
# test? org.ops4j.pax.exam:pax-exam-link-mvn:4.13.1 -> !!!groupId-not-found!!!
# test? org.slf4j:slf4j-api:1.7.30 -> >=dev-java/slf4j-api-1.7.30:0

DEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}"

S="${WORKDIR}/${P}-src"

PATCHES=(
	"${FILESDIR}/${P}-asm7+.patch"
)

JAVA_ENCODING="iso-8859-1"

JAVA_GENTOO_CLASSPATH="asm-9,zstd-jni,brotli-dec,xz-java"
JAVA_SRC_DIR="src/main/java"

src_prepare() {
	default
}
