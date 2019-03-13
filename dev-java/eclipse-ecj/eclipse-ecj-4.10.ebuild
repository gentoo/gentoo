# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PN="ecj"
DMF="R-${PV}-201812060815"

DESCRIPTION="Eclipse Compiler for Java"
HOMEPAGE="http://www.eclipse.org/"
SRC_URI="http://download.eclipse.org/eclipse/downloads/drops4/${DMF}/${MY_PN}src-${PV}.jar"

LICENSE="EPL-1.0"
KEYWORDS="~amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~x86-solaris"
SLOT="4.10"
IUSE="+ant"

COMMON_DEP="
	app-eselect/eselect-java
	dev-java/ant-core"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-11"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-11
	app-arch/unzip"
PDEPEND="
	ant? ( ~dev-java/ant-eclipse-ecj-${PV} )"

JAVA_JAR_FILENAME="${MY_PN}.jar"
JAVA_GENTOO_CLASSPATH="ant-core"

S="${WORKDIR}"

# See https://bugs.eclipse.org/bugs/show_bug.cgi?id=479134 for details
java_prepare() {
	# These have their own package.
	rm org/eclipse/jdt/core/JDTCompilerAdapter.java || die
	rm -r org/eclipse/jdt/internal/antadapter || die

	# JavaCore is not distributed in the jar
	sed -i -e '/import org.eclipse.jdt.core.JavaCore;/d' \
		-e 's|JavaCore.getOptions()||g' \
		org/eclipse/jdt/internal/compiler/batch/ClasspathDirectory.java
}

src_compile() {
	java-pkg-simple_src_compile
	find org META-INF -type f ! -name "*.java" | xargs jar uvf "${JAVA_JAR_FILENAME}" || die "jar update failed"
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dolauncher ${MY_PN}-${SLOT} --main \
		org.eclipse.jdt.internal.compiler.batch.Main
}

pkg_postinst() {
	einfo "To select between slots of ECJ..."
	einfo " # eselect ecj"

	eselect ecj update ecj-${SLOT}
}

pkg_postrm() {
	eselect ecj update
}
