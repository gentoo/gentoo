# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source examples"

inherit java-pkg-2 java-ant-2

DESCRIPTION="JFlex is a lexical analyzer generator for Java"
HOMEPAGE="http://www.jflex.de/"
SRC_URI="http://${PN}.de/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc64 x86 ~amd64-fbsd ~ppc-macos ~x64-macos ~x86-macos"

CDEPEND="dev-java/ant-core:0
	=dev-java/javacup-0.11a_beta20060608:0
	dev-java/junit:0"

RDEPEND=">=virtual/jre-1.6
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.6
	${CDEPEND}"

IUSE="${JAVA_PKG_IUSE} source vim-syntax"

java_prepare() {
	# use a more convenient version number
	sed -i s:"\(name=\"version\" value=\"\)[^\"]*\"":"\1${PV}\"":g build.xml
	# fix bootstrapping
	sed -i s:"\(name=\"bootstrap.version\" value=\"\)[^\"]*\"":"\1${PV}\"":g \
		build.xml
	# add javadoc capability to build.xml
	sed -i s,"\(</project>\)",\
"\n  <target depends=\"compile\" name=\"javadoc\">\n    <javadoc \
packagenames=\"jflex\" sourcepath=\"src/main/java:build/generated-\
sources\" destdir=\"javadoc\" version=\"true\" />\n  </target>\n\1",g \
		build.xml
}

# TODO: Try to avoid using bundled jar (See bug #498874)
#

EANT_GENTOO_CLASSPATH_EXTRA="lib/${P}.jar"

# Currently, this package uses an included JFlex.jar file to bootstrap.
# Upstream was contacted and this bootstrap is really needed. The only way to
# avoid it would be to use a supplied pre-compiled .scanner file.
JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="
	ant-core
	javacup
"
WANT_ANT_TASKS="javacup"

src_compile() {
	java-pkg-2_src_compile

	# Compile another time, using our generated jar; for sanity.
	cp build/${P}.jar ${EANT_GENTOO_CLASSPATH_EXTRA}
	java-pkg-2_src_compile
}

# EANT_TEST_GENTOO_CLASSPATH doesn't support EANT_GENTOO_CLASSPATH_EXTRA yet.
RESTRICT="test"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar build/${P}.jar ${PN}.jar
	java-pkg_dolauncher "${PN}" --main "${PN}.Main"
	java-pkg_register-ant-task

	if use doc ; then
		dodoc doc/manual.pdf changelog.md
		dohtml -r doc/*
		java-pkg_dojavadoc javadoc
	fi

	use examples && java-pkg_doexamples examples
	use source && java-pkg_dosrc src/main

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins "${S}/lib/${PN}.vim"
	fi
}
