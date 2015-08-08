# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WANT_ANT_TASKS="ant-nodeps ant-trax"
JAVA_PKG_IUSE="doc source examples"

inherit eutils java-pkg-2 java-ant-2

MY_PV="${PV//./_}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Apache's Axis1 implementation of the SOAP (Simple Object Access Protocol)"
HOMEPAGE="http://ws.apache.org/axis/index.html"
SRC_URI="mirror://apache/ws/${PN}/${MY_PV}/${PN}-src-${MY_PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="amd64 x86"
IUSE="debug"

CDEPEND="dev-java/commons-discovery:0
	dev-java/wsdl4j:0
	dev-java/sun-jaf:0
	dev-java/commons-logging:0
	java-virtuals/javamail:0
	dev-java/ant-core:0
	dev-java/bsf:2.3
	dev-java/castor:1.0
	dev-java/commons-httpclient:3
	dev-java/commons-net:0
	dev-java/sun-jimi:0
	dev-java/servletapi:2.4
	dev-java/saaj:0
	dev-java/jax-rpc:0
	dev-java/log4j:0
	dev-java/xml-commons:0
	dev-java/xml-xmlbeans:1"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.6
	${CDEPEND}"

# uses enum as identifier
JAVA_PKG_WANT_SOURCE="1.4"
JAVA_PKG_WANT_TARGET="1.4"

S="${WORKDIR}/${MY_P}"

AXIS_NAME="${PN}-${SLOT}"

# not declared mandatory but fails without it
# mailapi.jar would be enough but that's only in -bin, mail.jar superseedes
EANT_GENTOO_CLASSPATH="sun-jaf,javamail,log4j,xml-xmlbeans-1,servletapi-2.4,bsf-2.3,sun-jimi,commons-httpclient-3,castor-1.0,xml-commons,commons-net"
EANT_EXTRA_ARGS="-Ddeprecation=false -Dbase.path=/opt
-Dservlet.jar=servlet-api.jar -Dwsdl4j-1.5.1.jar=wsdl4j.jar
-Dcommons-logging-1.0.4.jar=commons-logging.jar"
EANT_BUILD_TARGET="compile"
EANT_DOC_TARGET="javadocs"
EANT_NEEDS_TOOLS="true"

#TODO-tests require Atlassian clover, need to figure out which ones
RESTRICT="test"

java_prepare() {
	# remove some <copy> actions
	epatch "${FILESDIR}/${P}-build.xml.patch"
	# remove exact lib paths and global java.classpath from classpath
	epatch "${FILESDIR}/${P}-path_refs.xml.patch"
	# add missing target to javac, xml rewriting would break entities
	epatch "${FILESDIR}/${P}-tools-build.xml.patch"
	# remove most of <available> checks
	epatch "${FILESDIR}/${P}-targets.xml.patch"
	# this clashes with java6 method
	epatch "${FILESDIR}/${P}-java6.patch"

	# fix CVE-2014-3596 and bug 520304
	epatch "${FILESDIR}/${P}-JSSESocketFactory.java.patch"

	# and replace them with predefined properties
	cp "${FILESDIR}/build.properties" . \
		|| die "failed to copy build.properties from ${FILESDIR}"

	rm -rf "${S}"/docs/apiDocs || die

	#Remove test till they are working
	rm -rf "${S}"/test || die
	#cd "${S}"/test
	#mv build_ant.xml build.xml
	cd "${S}"/webapps/axis/WEB-INF/lib
	rm -v *.jar || die

	cd "${S}/lib"
	mv saaj.jar endorsed/ || die
	rm -v *.jar || die
	java-pkg_jar-from --build-only ant-core
	java-pkg_jar-from wsdl4j wsdl4j.jar
	java-pkg_jar-from commons-logging commons-logging.jar
	java-pkg_jar-from commons-discovery commons-discovery.jar

	if use debug; then
		EANT_EXTRA_ARGS+=" -Ddebug=on"
	else
		EANT_EXTRA_ARGS+=" -Ddebug=off"
	fi

	cd "${S}"
	java-ant_rewrite-classpath
	java-ant_rewrite-bootclasspath auto build.xml "lib/endorsed/xml-apis-2.6.2.jar:lib/endorsed/xercesImpl-2.6.2.jar:lib/endorsed/saaj.jar"
	sed -i '/<bootclasspath refid="boot.classpath"/d' build.xml || die
}

src_install() {
	dodir /usr/share/${AXIS_NAME}
	mv build/lib/axis-ant.jar build/lib/ant-axis.jar || die
	java-pkg_dojar build/lib/axis.jar
	java-pkg_dojar build/lib/ant-axis.jar
	java-pkg_dojar build/lib/jaxrpc.jar
	java-pkg_register-ant-task
	dodir /usr/share/${AXIS_NAME}/webapps

	cp -pR "${S}"/webapps/axis "${D}"/usr/share/${AXIS_NAME}/webapps || die

	dodoc NOTICE README
	dohtml release-notes.html changelog.html

	if use doc; then
		java-pkg_dojavadoc build/javadocs/
		dohtml -r docs/*
		dodoc xmls/*
	fi

	use source && java-pkg_dosrc src
	use examples && java-pkg_doexamples samples
}
