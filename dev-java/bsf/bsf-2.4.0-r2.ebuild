# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/bsf/bsf-2.4.0-r2.ebuild,v 1.3 2015/07/05 15:34:23 monsieurp Exp $

EAPI="5"
JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 eutils java-ant-2

DESCRIPTION="Bean Script Framework"
HOMEPAGE="http://commons.apache.org/bsf/"
SRC_URI="mirror://apache/jakarta/bsf/source/${PN}-src-${PV}.tar.gz"
LICENSE="Apache-2.0"
SLOT="2.3"
KEYWORDS="~amd64 ~x86 ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

# If you add new ones, add them to ant-apache-bsf too for use dependencies
IUSE="javascript python tcl"

CDEPEND="dev-java/commons-logging:0
	dev-java/xalan:0
	python? ( dev-java/jython:2.7 )
	javascript? ( dev-java/rhino:1.6 )
	tcl? ( dev-java/jacl:0 )"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.6
	${CDEPEND}"

JAVA_ANT_REWRITE_CLASSPATH="yes"

java_prepare() {
	rm -v lib/*.jar || die
	rm samples/*/*.class || die

	java-ant_ignore-system-classes

	# somebody forgot to add them to source tarball... fetched from svn
	cp "${FILESDIR}/${P}-build-properties.xml" build-properties.xml || die

	# Silence javadoc.
	java-ant_xml-rewrite -f build.xml -c \
		-e javadoc \
		-a failonerror \
		-v no

	# http://bugs.jython.org/issue1814
	# Also, bsf is an old project (2011) and hasn't officially taken the leap to
	# jython-2.7. This patch fixes the issue.
	epatch "${FILESDIR}"/${P}-PyJavaInstance.patch
}

src_compile() {
	local pkgs="commons-logging,xalan"
	local antflags="-Dxalan.present=true"

	if use python; then
		antflags="${antflags} -Djython.present=true"
		pkgs="${pkgs},jython-2.7"
	fi
	if use javascript; then
		antflags="${antflags} -Drhino.present=true"
		pkgs="${pkgs},rhino-1.6"
	fi
	if use tcl; then
		antflags="${antflags} -Djacl.present=true"
		pkgs="${pkgs},jacl"
	fi

	local cp="$(java-pkg_getjars ${pkgs})"
	eant -Dgentoo.classpath="${cp}" ${antflags} jar

	# stupid clean
	mv build/lib/${PN}.jar "${S}" || die
	use doc && eant -Dgentoo.classpath="${cp}" ${antflags} javadocs
}

src_install() {
	java-pkg_dojar ${PN}.jar

	java-pkg_dolauncher ${PN} --main org.apache.bsf.Main

	dodoc CHANGES.txt NOTICE.txt README.txt RELEASE-NOTE.txt TODO.txt || die

	use doc && java-pkg_dojavadoc build/javadocs
	use examples && java-pkg_doexamples samples
	use source && java-pkg_dosrc src/org

	java-pkg_register-optional-dependency bsh,groovy-1,jruby
}

pkg_postinst() {
	elog "Support for python, javascript, and tcl is controlled via USE flags."
	elog "Also, following languages can be supported just by installing"
	elog "respective package with USE=\"bsf\": BeanShell (dev-java/bsh),"
	elog "Groovy (dev-java/groovy) and JRuby (dev-java/jruby)"
}
