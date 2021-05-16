# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Expression language engine, can be embedded in applications and frameworks"
HOMEPAGE="http://commons.apache.org/jexl/"
SRC_URI="mirror://apache/jakarta/commons/jexl/source/${P}-src.tar.gz"

CDEPEND="dev-java/commons-logging
		dev-java/junit:0"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.6
	test? ( dev-java/ant-junit )
	${CDEPEND}"

LICENSE="Apache-2.0"
SLOT="1.0"
KEYWORDS="amd64 x86"
IUSE=""

S="${WORKDIR}/${P}-src"

java_prepare() {
	# https://issues.apache.org/jira/browse/JEXL-31
	epatch "${FILESDIR}/${PV}-test-target.patch"

	mkdir -p target/lib && cd target/lib
	java-pkg_jar-from junit junit.jar
	java-pkg_jar-from commons-logging
}

src_test() {
	ANT_TASKS="ant-junit" eant test
}

src_install() {
	java-pkg_newjar target/${P}*.jar
	dodoc RELEASE-NOTES.txt
	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc "${S}"/src/java/*
}
