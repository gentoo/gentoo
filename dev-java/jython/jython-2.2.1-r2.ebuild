# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jython/jython-2.2.1-r2.ebuild,v 1.4 2014/03/10 16:57:18 johu Exp $

EAPI=4

JAVA_PKG_IUSE="readline source doc servletapi mysql postgres examples oracle"
#jdnc

inherit base java-pkg-2 java-ant-2

MY_PV="installer-2.2.1"
PYVER="2.2.3"

DESCRIPTION="An implementation of Python written in Java"
HOMEPAGE="http://www.jython.org"
SRC_URI="http://www.python.org/ftp/python/${PYVER%_*}/Python-${PYVER}.tgz
mirror://sourceforge/${PN}/${PN}_${MY_PV}.jar"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

CDEPEND="
	dev-java/jakarta-oro:2.0
	readline? ( >=dev-java/libreadline-java-0.8.0:0 )
	mysql? ( >=dev-java/jdbc-mysql-3.1:0 )
	postgres? ( dev-java/jdbc-postgresql:0 )
	oracle? ( dev-java/jdbc-oracle-bin:10.2 )
	servletapi? ( java-virtuals/servlet-api:2.5 )
	!<=dev-java/freemarker-2.3.10"
RDEPEND="${CDEPEND}
	>=virtual/jre-1.5"
DEPEND="${CDEPEND}
	>=virtual/jdk-1.5
	dev-java/javacc"

S="${WORKDIR}"

#Tests currently very broken. Need to investigate whether that
#is jython's or gentoo's doing.
RESTRICT="test"

java_prepare() {
	epatch "${FILESDIR}/${P}-build.xml.patch"

	rm -Rfv org || die "Unable to remove class files."
	find . -iname '*.jar' | xargs rm -fv || die "Unable to remove bundled jars"

	echo javacc.jar="$(java-pkg_getjars --build-only javacc)" > ant.properties

	if use readline; then
		echo "readline.jar=$(java-pkg_getjars libreadline-java)" >> \
		ant.properties
	fi
	if use servletapi; then
		echo "servlet.jar=$(java-pkg_getjar --virtual servlet-api-2.5 servlet-api.jar)" \
		>> ant.properties
	fi
	if use mysql; then
		echo "mysql.jar=$(java-pkg_getjar jdbc-mysql jdbc-mysql.jar)" \
		>> ant.properties
	fi

	if use postgres; then
		echo \
		"postgresql.jar=$(java-pkg_getjar jdbc-postgresql jdbc-postgresql.jar)"\
		 >> ant.properties
	fi

	if use oracle; then
		echo \
		"oracle.jar=$(java-pkg-getjar jdbc-oracle-bin-10.2 ojdbc14.jar)" \
		>> ant.properties
	fi
}

src_compile() {
	local antflags="-Dbase.path=src/java -Dsource.dir=src/java/src"
	local pylib="Python-${PYVER}/Lib"
	antflags="${antflags} -Dpython.lib=${pylib} -Dsvn.checkout.dir=."
	LC_ALL=C eant ${antflags} developer-build $(use_doc javadoc)
}

src_test() {
	local antflags="-Dbase.path=src/java -Dsource.dir=src/java/src"
	antflags="${antflags} -Dpython.home=dist"
	local pylib="Python-${PYVER}/Lib"
	antflags="${antflags} -Dpython.lib=${pylib}"
	eant ${antflags} bugtest
}

src_install() {
	java-pkg_dojar "dist/${PN}.jar"

	dodoc README.txt NEWS ACKNOWLEDGMENTS
	use doc && dohtml -r Doc/*

	local java_args="-Dpython.home=/usr/share/jython"
	java_args="${java_args} -Dpython.cachedir=\${HOME}/.jythoncachedir"

	java-pkg_dolauncher jythonc \
						--main "org.python.util.jython" \
						--java_args "${java_args}" \
						--pkg_args "${java_args} /usr/share/jython/tools/jythonc/jythonc.py"

	java-pkg_dolauncher jython \
						--main "org.python.util.jython" \
						--pkg_args "${java_args}"

	insinto /usr/share/${PN}
	doins -r dist/Lib registry

	insinto /usr/share/${PN}/tools
	doins -r dist/Tools/*

	use doc && java-pkg_dojavadoc dist/Doc/javadoc
	use source && java-pkg_dosrc src
	use examples && java-pkg_doexamples dist/Demo/*
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
}
