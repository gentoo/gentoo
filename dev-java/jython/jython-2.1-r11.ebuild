# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jython/jython-2.1-r11.ebuild,v 1.11 2012/01/01 12:24:17 sera Exp $

inherit base java-pkg-2

DESCRIPTION="An implementation of Python written in Java"
HOMEPAGE="http://www.jython.org"
MY_PV="21"
#SRC_URI="mirror://sourceforge/${PN}/${PN}-${MY_PV}.class"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd"
IUSE="readline source doc"
# servlet

CDEPEND="=dev-java/jakarta-oro-2.0*
	readline? ( >=dev-java/libreadline-java-0.8.0 )"
#	servlet? ( >=www-servers/tomcat-5.0 )
RDEPEND=">=virtual/jre-1.4
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.4
	source? ( app-arch/zip )
	${CDEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${PV}-assert.patch
	epatch ${FILESDIR}/${PV}-assert-SimpleCompiler.py.patch

	# bug #160861
	rm -rf org/apache
}

src_compile() {
	local cp="$(java-pkg_getjars jakarta-oro-2.0)"
	local exclude=""

	if use readline ; then
		cp=${cp}:$(java-pkg_getjars libreadline-java)
	else
		exclude="${exclude} ! -name ReadlineConsole.java"
	fi

	#if use servlet; then
	#	cp=${cp}:$(java-pkg_getjars servlet)
	#else
		exclude="${exclude} ! -name PyServlet.java"
	#fi

	ejavac -classpath ${cp} -nowarn $(find org -name "*.java" ${exclude})

	find org -name "*.class" | xargs jar cf ${PN}.jar

	# bug 115551
	cd Lib/jxxload_help
	ejavac -classpath ${S}/${PN}.jar -nowarn *.java
	rm -f *.java Makefile
}

src_install() {
	java-pkg_dojar ${PN}.jar

	dodoc README.txt NEWS ACKNOWLEDGMENTS
	use doc && java-pkg_dohtml -A .css .jpg .gif -r Doc/*

	java-pkg_dolauncher jythonc \
						--main "org.python.util.jython" \
						--java_args "-Dpython.home=/usr/share/jython" \
						--pkg_args "/usr/share/jython/tools/jythonc/jythonc.py"

	java-pkg_dolauncher jython \
						--main "org.python.util.jython" \
						--java_args "-Dpython.home=/usr/share/jython"

	dodir /usr/share/jython/cachedir
	chmod a+rw ${D}/usr/share/jython/cachedir

	rm Demo/jreload/example.jar
	insinto /usr/share/${PN}
	doins -r Lib Demo registry

	insinto /usr/share/${PN}/tools
	doins -r Tools/*

	use source && java-pkg_dosrc com org
}

pkg_postinst() {
	if use readline; then
		elog "To use readline you need to add the following to your registry"
		elog
		elog "python.console=org.python.util.ReadlineConsole"
		elog "python.console.readlinelib=GnuReadline"
		elog
		elog "The global registry can be found in /usr/share/${PN}/registry"
		elog "User registry in \$HOME/.jython"
		elog "See http://www.jython.org/docs/registry.html for more information"
		elog ""
	fi

	elog "This revision renames org.python.core.Py.assert to assert_."
	elog "This is the solution that upstream will use in the next release."
	elog "Just note that this revision is not API compatible with vanilla 2.1."
	elog "https://bugs.gentoo.org/show_bug.cgi?id=142099"
}
