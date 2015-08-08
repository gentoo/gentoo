# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="source"
JAVA_PKG_WANT_BOOTCLASSPATH="1.5"
WANT_ANT_TASKS="ant-contrib"

inherit eutils java-pkg-2 java-ant-2

MY_PN="mysql-connector-java"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="MySQL JDBC driver"
HOMEPAGE="http://www.mysql.com/products/connector/j/"
SRC_URI="mirror://mysql/Downloads/Connector-J/${MY_P}.tar.gz"

LICENSE="GPL-2-with-MySQL-FLOSS-exception"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

IUSE="c3p0 log4j"

COMMON_DEP="
	dev-java/slf4j-api:0
	log4j? ( dev-java/log4j )
	c3p0? ( dev-java/c3p0 )"

RDEPEND=">=virtual/jre-1.6
	${COMMON_DEP}"

DEPEND=">=virtual/jdk-1.6
	${COMMON_DEP}"

S="${WORKDIR}/${MY_P}"

java_prepare() {
	epatch "${FILESDIR}/5.0.5-remove-jboss-dependency-from-tests.patch"

	# http://bugs.mysql.com/bug.php?id=28286
	epatch "${FILESDIR}/5.0.5-dist-target-depends.patch"

	# Use java6 for everything except jdbc3 - #283848
	epatch "${FILESDIR}/5.1.14-java6.patch"

	find . -name '*.jar' -print -delete || die

	# use test && mkdir src/lib-nodist # needed, or ant will fail

	cd src/lib
	java-pkg_jar-from slf4j-api
	use log4j && java-pkg_jar-from log4j
	use c3p0 && java-pkg_jar-from c3p0
}

JAVA_ANT_IGNORE_SYSTEM_CLASSES="true"
EANT_BUILD_TARGET="dist"

src_compile() {
	# Cannot use rewrite-bootclasspath because of the jdbc4 part.
	java-pkg-2_src_compile \
		-Dgentoo.bootclasspath="$(java-pkg_get-bootclasspath 1.5)"
}

# Tests need a mysql DB to exist.
RESTRICT="test"

src_test() {
	cd src/lib
	java-pkg_jar-from junit

	cd "${S}"
	ANT_TASKS="ant-junit" eant test -Dcom.mysql.jdbc.noCleanBetweenCompiles=true
}

src_install() {
	# Skip bytecode check because we want two versions there
	JAVA_PKG_STRICT= java-pkg_newjar build/${MY_P}-SNAPSHOT/${MY_P}-SNAPSHOT-bin.jar ${PN}.jar

	dodoc README CHANGES
	dohtml docs/*.html

	use source && java-pkg_dosrc src/com src/org
}
