# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

WANT_ANT_TASKS="ant-antlr ant-swing ant-junit"
JAVA_PKG_IUSE="doc source"
JAVA_PKG_WANT_BOOTCLASSPATH="1.5"

inherit java-pkg-2 java-ant-2

MY_PV="3.1"
DESCRIPTION="A powerful, ultra-high performance object / relational persistence and query service for Java"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.hibernate.org"
LICENSE="LGPL-2"
IUSE=""
SLOT="3.1"
KEYWORDS="amd64 x86"

COMMON_DEPEND="
	>=dev-java/antlr-2.7.7:0[java]
	dev-java/c3p0:0
	dev-java/cglib:3
	dev-java/commons-collections:0
	dev-java/commons-logging:0
	dev-java/dom4j:1
	dev-java/ehcache:0
	dev-java/oscache:0
	dev-java/proxool:0
	dev-java/swarmcache:1.0
	java-virtuals/transaction-api:0
	dev-java/sun-jacc-api:0
	dev-java/ant-core:0
	dev-java/asm:2.2"
RDEPEND=">=virtual/jre-1.6
	${COMMON_DEPEND}"
DEPEND=">=virtual/jdk-1.6
	${COMMON_DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

# Avoid this to happen.
#    [javac] /var/tmp/portage/dev-java/hibernate-3.1.3-r4/work/hibernate-3.1/src/org/hibernate/dialect/MimerSQLDialect.java:13: error: unmappable character for encoding UTF8
#    [javac]  * @author Fredrik �lund <fredrik.alund@mimer.se>
JAVA_ANT_ENCODING="ISO-8859-1"

java_prepare() {
	java-ant_rewrite-bootclasspath 1.5

	# this depends on jboss
	rm src/org/hibernate/cache/JndiBoundTreeCacheProvider.java \
		src/org/hibernate/cache/TreeCache.java \
		src/org/hibernate/cache/TreeCacheProvider.java

	rm -v *.jar lib/*.jar || die
}

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="
c3p0,commons-collections,commons-logging,cglib-3,transaction-api
dom4j-1,ehcache,oscache,proxool,swarmcache-1.0
sun-jacc-api,antlr,ant-core,asm-2.2
"
EANT_EXTRA_ARGS="-Dnosplash -Ddist.dir=dist"

src_install() {
	java-pkg_dojar hibernate3.jar
	dodoc changelog.txt readme.txt
	use doc && java-pkg_dohtml -r doc/api doc/other doc/reference
	use source && java-pkg_dosrc src/*
}
