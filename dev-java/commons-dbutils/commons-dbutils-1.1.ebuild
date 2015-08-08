# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source test"

inherit base java-pkg-2 java-ant-2

DESCRIPTION="A small set of classes designed to make working with JDBC easier"
HOMEPAGE="http://commons.apache.org/dbutils/"
SRC_URI="mirror://apache/commons/dbutils/source/${P}-src.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=virtual/jdk-1.4
	test? ( dev-java/ant-junit )"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}/${P}-src"

PATCHES=( "${FILESDIR}/1.1-tests.patch" )
JAVA_ANT_REWRITE_CLASSPATH="yes"

src_install() {
	java-pkg_newjar target/${P}.jar

	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/java/*
}
