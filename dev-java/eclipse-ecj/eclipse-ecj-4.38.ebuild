# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DMF="R-${PV/_rc/RC}-202512010920"

DESCRIPTION="Eclipse Compiler for Java"
HOMEPAGE="https://projects.eclipse.org/projects/eclipse.jdt"
SRC_URI="https://download.eclipse.org/eclipse/downloads/drops4/${DMF}/ecjsrc-${PV/_rc/RC}.jar"
S="${WORKDIR}"

LICENSE="EPL-1.0"
SLOT="4.38"
KEYWORDS="~amd64 ~arm64"

BDEPEND="app-arch/unzip"

# jdk-25 because of compilation errors with jdk-21
DEPEND="
	>=dev-java/ant-1.10.15:0
	>=virtual/jdk-25:*
"

# ./org/eclipse/jdt/internal/compiler/env/ICompilationUnit.java:64:
# error: pattern matching in instanceof is not supported in -source 11
# 	if (environment.nameEnvironment instanceof IModuleAwareNameEnvironment modEnv) {
# 	                                                                       ^
#   (use -source 16 or higher to enable pattern matching in instanceof)
RDEPEND=">=virtual/jre-17:*"

DOCS=( org/eclipse/jdt/core/README.md )
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
	find -type f \
		! -name '*.java' \
		! -name 'package.html' \
		! -path '*/grammar/*' \
		! -path '*/OSGI-INF/*' |
		xargs cp --parent -t "${JAVA_RESOURCE_DIRS}" || die
}
