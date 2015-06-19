# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/castor/castor-1.1.1-r3.ebuild,v 1.4 2015/06/13 11:37:20 ago Exp $
EAPI=5

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Data binding framework for Java"
HOMEPAGE="http://www.castor.org"
SRC_URI="http://dist.codehaus.org/${PN}/${PV}/${P}-src.tgz"

#SRC_URI="mirror://gentoo/${P}.tar.bz2"
# svn co https://svn.codehaus.org/castor/castor/tags/1.0.3/ castor-1.0.3
# cd castor-1.0.3
# mvn ant:ant
# do some magic to build.xml
# rm lib/*
# cd ../
# tar cjvf castor-1.0.3.tar.bz2 --exclude=.svn castor-1.0.3

LICENSE="Exolab"
SLOT="1.0"
KEYWORDS="amd64 x86"
IUSE=""

# tests and full documentation when support will be added
#	dev-java/log4j
#	~dev-java/servletapi-2.4
#	dev-java/junit"

CDEPEND="dev-java/cglib:3
	dev-java/commons-logging
	=dev-java/jakarta-oro-2.0*
	=dev-java/jakarta-regexp-1.3*
	java-virtuals/transaction-api
	=dev-java/ldapsdk-4.1*
	dev-java/ant-core"

DEPEND=">=virtual/jdk-1.6
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

src_unpack() {
	unpack ${A}

	java-ant_rewrite-classpath "${S}/anttask/build.xml"

	cd "${S}/lib"
	rm -v *.jar tests/*.jar
	java-pkg_jar-from cglib-3 cglib.jar
	java-pkg_jar-from commons-logging \
		commons-logging-api.jar	commons-logging-1.1.jar
	java-pkg_jar-from jakarta-oro-2.0
	java-pkg_jar-from jakarta-regexp-1.3
	java-pkg_jar-from transaction-api
	java-pkg_jar-from ldapsdk-4.1 ldapjdk.jar
	java-pkg_jar-from ant-core ant.jar

	# These are only used for tests or documentation
	#java-pkg_jar-from junit
	#java-pkg_jar-from adaptx-0.9
	#java-pkg_jar-from log4j
	#java-pkg_jar-from servletapi-2.4 servlet-api.jar
	use doc && mkdir "${S}/bin/lib"
	java-pkg_filter-compiler jikes
}

#src_prepare() {
#	# http://jira.codehaus.org/browse/CASTOR-2008
#	epatch "${FILESDIR}/1.1.1-jdk-1.4.patch"
#}

# clean target is borked
# http://jira.codehaus.org/browse/CASTOR-2009
EANT_BUILD_XML="src/build.xml"
EANT_GENTOO_CLASSPATH="ant-core"

# Needs for example mockejb which is not packaged yet
#src_test() {
#	cd "${S}"/src/
#	eant tests
#}

src_install() {
	cd dist
	for jar in *.jar; do
		java-pkg_newjar ${jar} ${jar//-${PV}}
	done
	cd ..
	dodoc src/etc/CHANGELOG || die
	java-pkg_register-ant-task
	use source && java-pkg_dosrc */main/java/org
	use doc && java-pkg_dojavadoc build/doc/javadoc
	use examples && java-pkg_doexamples src/examples
}
