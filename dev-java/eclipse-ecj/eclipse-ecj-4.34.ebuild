# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
# 3.38.0 according to
# https://github.com/eclipse-jdt/eclipse.jdt.core/blob/R4_32/org.eclipse.jdt.core.compiler.batch/pom.xml#L20
MAVEN_ID="org.eclipse.jdt:org.eclipse.jdt.core.compiler.batch:3.38.0"

inherit java-pkg-2 java-pkg-simple

DMF="R-${PV/_rc/RC}-202411201800"

DESCRIPTION="Eclipse Compiler for Java"
HOMEPAGE="https://projects.eclipse.org/projects/eclipse.jdt"
SRC_URI="https://download.eclipse.org/eclipse/downloads/drops4/${DMF}/ecjsrc-${PV/_rc/RC}.jar"
S="${WORKDIR}"

LICENSE="EPL-1.0"
SLOT="4.34"
# KEYWORDS="~amd64 ~arm64 ~ppc64" # Seems to depend on higher jdk which is not LTS

BDEPEND="app-arch/unzip"

# restrict to >=virtual/jdk-23:*
# ./org/eclipse/jdt/internal/compiler/apt/model/ElementsImpl9.java:347: error: cannot find symbol
#     public DocCommentKind getDocCommentKind(Element e) {
#            ^
#   symbol:   class DocCommentKind
#   location: class ElementsImpl9
DEPEND="
	>=dev-java/ant-1.10.15:0
	>=virtual/jdk-23:*
"

# restrict to >=virtual/jre-21:*
# ./org/eclipse/jdt/internal/compiler/lookup/TypeBinding.java:722:
# error: unconditional patterns in instanceof are not supported in -source 17
# 	return isRecord() && components() instanceof RecordComponentBinding [] components && components.length > 0;
# 	                                  ^
#   (use -source 21 or higher to enable unconditional patterns in instanceof)
RDEPEND=">=virtual/jre-21:*"

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
		! -path '*/OSGI-INF/*' \
		| xargs cp --parent -t "${JAVA_RESOURCE_DIRS}" || die
}
