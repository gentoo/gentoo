# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PN="ecj"
DMF="R-${PV}-202303020300"

DESCRIPTION="Eclipse Compiler for Java"
HOMEPAGE="https://www.eclipse.org/"
SRC_URI="https://download.eclipse.org/eclipse/downloads/drops4/${DMF}/${MY_PN}src-${PV}.jar"
S="${WORKDIR}"

LICENSE="EPL-1.0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux"
SLOT="4.27"
IUSE="+ant"

COMMON_DEP="
	app-eselect/eselect-java
	dev-java/ant-core:0"
# ElementsImpl9.java:206: error:
# method does not override or implement a method from a supertype
DEPEND="${COMMON_DEP}
	>=virtual/jdk-21:*
	app-arch/unzip"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-11:*"
PDEPEND="
	ant? ( ~dev-java/ant-eclipse-ecj-${PV} )"

JAVA_GENTOO_CLASSPATH="ant-core"
JAVA_JAR_FILENAME="${MY_PN}.jar"
JAVA_LAUNCHER_FILENAME="${MY_PN}-${SLOT}"
JAVA_MAIN_CLASS="org.eclipse.jdt.internal.compiler.batch.Main"
JAVA_RESOURCE_DIRS="res"

# See https://bugs.eclipse.org/bugs/show_bug.cgi?id=479134 for details
src_prepare() {
	java-pkg-2_src_prepare

	# These have their own package.
	rm org/eclipse/jdt/core/JDTCompilerAdapter.java || die
	rm -r org/eclipse/jdt/internal/antadapter || die

	mkdir "${JAVA_RESOURCE_DIRS}" || die
	find -type f \
		! -name '*.java' \
		| xargs cp --parent -t "${JAVA_RESOURCE_DIRS}" || die
}

pkg_postinst() {
	einfo "To select between slots of ECJ..."
	einfo " # eselect ecj"

	eselect ecj update ecj-${SLOT}
}

pkg_postrm() {
	eselect ecj update
}
