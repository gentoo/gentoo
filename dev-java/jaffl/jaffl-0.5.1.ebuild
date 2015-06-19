# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jaffl/jaffl-0.5.1.ebuild,v 1.5 2013/07/23 17:23:33 vincent Exp $

EAPI="5"

JAVA_PKG_IUSE="doc source"
WANT_ANT_TASKS="ant-nodeps"

inherit java-pkg-2 java-ant-2

DESCRIPTION="An abstracted interface to invoking native functions from java"
HOMEPAGE="http://kenai.com/projects/jaffl"
SRC_URI="http://github.com/wmeissner/${PN}/tarball/${PV} -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="test"

CDEPEND="dev-java/jffi:0.4
	dev-java/jnr-x86asm:0
	dev-java/asm:3"

RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${CDEPEND}
	test? (
		dev-java/junit:4
		dev-java/ant-junit4:0
		dev-java/hamcrest-core:0
	)"

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}" || die
	mv * "${P}" || die
}

java_prepare() {
	rm -vf lib/{.,junit*}/*.jar

	epatch "${FILESDIR}/library-path-${PV}.patch" || die

	java-pkg_jar-from --into lib jffi-0.4
	java-pkg_jar-from --into lib jnr-x86asm
	java-pkg_jar-from --into lib asm-3 asm.jar asm-3.2.jar
	java-pkg_jar-from --into lib asm-3 asm-analysis.jar asm-analysis-3.2.jar
	java-pkg_jar-from --into lib asm-3 asm-commons.jar asm-commons-3.2.jar
	java-pkg_jar-from --into lib asm-3 asm-tree.jar asm-tree-3.2.jar
	java-pkg_jar-from --into lib asm-3 asm-util.jar asm-utils-3.2.jar
	java-pkg_jar-from --into lib asm-3 asm-xml.jar asm-xml-3.2.jar
}

EANT_EXTRA_ARGS="-Dreference.jffi.jar=lib/jffi.jar \
	-Dreference.jnr-x86asm.jar=lib/jnr-x86asm.jar \
	-Dproject.jffi=\"${S}\" \
	-Dproject.jnr-x86asm=\"${S}\"
	-D\"already.built.${S}\"=true"

src_install() {
	java-pkg_dojar "dist/${PN}.jar"
	use doc && java-pkg_dojavadoc dist/javadoc
	use source && java-pkg_dosrc src/*
}

src_test() {
	local paths="$(java-config -di jnr-x86asm,jffi-0.4):${S}/build"
	ANT_TASKS="ant-junit4 ant-nodeps" eant test \
		-Drun.jvmargs="-Djava.library.path=${paths}" \
		-Dlibs.junit_4.classpath="$(java-pkg_getjars junit-4,hamcrest-core)" ${EANT_EXTRA_ARGS}
}
