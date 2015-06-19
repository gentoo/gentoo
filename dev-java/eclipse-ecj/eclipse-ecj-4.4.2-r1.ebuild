# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/eclipse-ecj/eclipse-ecj-4.4.2-r1.ebuild,v 1.2 2015/03/31 18:51:35 ulm Exp $

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PN="ecj"
DMF="R-${PV}-201502041700"

DESCRIPTION="Eclipse Compiler for Java"
HOMEPAGE="http://www.eclipse.org/"
SRC_URI="http://download.eclipse.org/eclipse/downloads/drops4/${DMF}/${MY_PN}src-${PV}.jar"

LICENSE="EPL-1.0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
SLOT="4.4"
IUSE="+ant"

COMMON_DEP="
	|| ( app-eselect/eselect-java app-eselect/eselect-ecj )"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.6"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.6
	app-arch/unzip"
PDEPEND="
	ant? ( ~dev-java/ant-eclipse-ecj-${PV} )"

JAVA_JAR_FILENAME="${MY_PN}.jar"

java_prepare() {
	# These have their own package.
	rm org/eclipse/jdt/core/JDTCompilerAdapter.java || die
	rm -r org/eclipse/jdt/internal/antadapter || die

	rm build.xml || die
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
