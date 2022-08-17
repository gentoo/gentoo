# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.github.marschall:memoryfilesystem:2.3.0"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="An in memory implementation of a JSR-203 file system."
HOMEPAGE="https://github.com/marschall/memoryfilesystem"
SRC_URI="https://github.com/marschall/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

CP_DEPEND="
	dev-java/jakarta-annotations-api:0
"

DEPEND="
	>=virtual/jdk-11:*
	${CP_DEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

src_prepare() {
	default
	# https://github.com/marschall/memoryfilesystem/blob/2.3.0/pom.xml#L236-L259
	cat > src/main/java/module-info.java <<-EOF
		module com.github.marschall.memoryfilesystem {
			requires java.base;
			requires static jakarta.annotation;
			exports com.github.marschall.memoryfilesystem;
			provides  java.nio.file.spi.FileSystemProvider with
				com.github.marschall.memoryfilesystem.MemoryFileSystemProvider;
		}
	EOF
	sed \
		-e 's:javax\(.annotation.PreDestroy\):jakarta\1:' \
		-i src/main/java/com/github/marschall/memoryfilesystem/MemoryFileSystem.java || die
}
