# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DMF="R-${PV}-202211231800"

DESCRIPTION="Eclipse Compiler for Java"
HOMEPAGE="https://projects.eclipse.org/projects/eclipse.jdt"
SRC_URI="https://archive.eclipse.org/eclipse/downloads/drops4/${DMF}/ecjsrc-${PV}.jar"
S="${WORKDIR}"

LICENSE="EPL-1.0"
SLOT="4.26"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"

BDEPEND="app-arch/unzip"
COMMON_DEP="app-eselect/eselect-java"
DEPEND="${COMMON_DEP}
	>=dev-java/ant-1.10.14:0
	>=virtual/jdk-17:*"
RDEPEND="${COMMON_DEP}
	!dev-java/ant-eclipse-ecj:4.26
	>=virtual/jre-11:*"

JAVA_AUTOMATIC_MODULE_NAME="org.eclipse.jdt.core.compiler.batch"
JAVA_CLASSPATH_EXTRA="ant"
JAVA_JAR_FILENAME="ecj.jar"
JAVA_LAUNCHER_FILENAME="ecj-${SLOT}"
JAVA_MAIN_CLASS="org.eclipse.jdt.internal.compiler.batch.Main"
JAVA_RESOURCE_DIRS="res"

src_prepare() {
	java-pkg-2_src_prepare

	# Exception in thread "main" java.lang.SecurityException: Invalid signature file digest for Manifest main attributes
	rm META-INF/ECLIPSE_* || die

	mkdir "${JAVA_RESOURCE_DIRS}" || die
	find org META-INF -type f \
		! -name '*.java' \
		| xargs cp --parent -t "${JAVA_RESOURCE_DIRS}" || die
}
