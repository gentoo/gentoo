# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PN="ecj"
DMF="R-${PV}-201409250400"

DESCRIPTION="Eclipse Compiler for Java"
HOMEPAGE="http://www.eclipse.org/"
SRC_URI="http://download.eclipse.org/eclipse/downloads/drops4/${DMF}/${MY_PN}src-${PV}.jar"

LICENSE="EPL-1.0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
SLOT="4.4"
IUSE="+ant userland_GNU"

COMMON_DEP="
	app-eselect/eselect-java"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.6"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.6
	app-arch/unzip
	userland_GNU? ( sys-apps/findutils )"
PDEPEND="
	ant? ( ~dev-java/ant-eclipse-ecj-${PV} )"

S="${WORKDIR}"

JAVA_PKG_WANT_SOURCE=1.6
JAVA_PKG_WANT_TARGET=1.6

java_prepare() {
	# These have their own package.
	rm -f org/eclipse/jdt/core/JDTCompilerAdapter.java || die
	rm -fr org/eclipse/jdt/internal/antadapter || die

	rm build.xml || die
}

src_compile() {
	java-pkg-simple_src_compile
	find -name "*.properties" -or -name "*.rsc" -or -name "*.props" \
		 -or -wholename "*/META-INF/*" | xargs jar uvf "${S}/${PN}.jar" || die "jar update failed"
}

src_install() {
	java-pkg-simple_src_install

	java-pkg_dolauncher ${MY_PN}-${SLOT} --main \
		org.eclipse.jdt.internal.compiler.batch.Main

	java-pkg_newjar ${PN}.jar ${MY_PN}.jar
}

pkg_postinst() {
	einfo "To select between slots of ECJ..."
	einfo " # eselect ecj"

	eselect ecj update ecj-${SLOT}
}

pkg_postrm() {
	eselect ecj update
}
