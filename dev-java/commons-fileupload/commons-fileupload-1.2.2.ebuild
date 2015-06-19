# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-fileupload/commons-fileupload-1.2.2.ebuild,v 1.6 2014/08/10 20:10:47 slyfox Exp $

EAPI=4

JAVA_PKG_IUSE="doc source test"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Add robust, high-performance, file upload capability to your servlets and web applications"
HOMEPAGE="http://commons.apache.org/fileupload/"
SRC_URI="mirror://apache/commons/fileupload/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd"
IUSE=""

COMMON_DEP="
	dev-java/commons-io:1
	dev-java/portletapi:1
	java-virtuals/servlet-api:2.5"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.4"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.4
	test? (
		dev-java/ant-junit:0
	)"

S="${WORKDIR}/${P}-src"

JAVA_PKG_FILTER_COMPILER="jikes"

java_prepare() {
	# don't automatically run tests
	sed -i 's/depends="compile,test"/depends="compile"/' build.xml
	# upstream idea of using unless="noget" is somewhat flawed
	sed -i 's/depends="get-dep-commons-io.jar,get-dep-servlet-api.jar,get-dep-portlet-api.jar,get-dep-junit.jar,get-dep-maven-xdoc-plugin.jar,get-dep-maven-changelog-plugin.jar"//' build.xml
}

JAVA_ANT_REWRITE_CLASSPATH="yes"

EANT_GENTOO_CLASSPATH="commons-io-1,portletapi-1,servlet-api-2.5"
EANT_EXTRA_ARGS="-Dlibdir=target/lib"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar target/${P}-SNAPSHOT.jar

	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/java/*
}
