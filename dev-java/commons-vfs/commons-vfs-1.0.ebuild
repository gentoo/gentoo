# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="a single API for accessing various different file systems"
HOMEPAGE="http://commons.apache.org/vfs/"
SRC_URI="mirror://apache/jakarta/${PN/-//}/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

COMMON_DEP="
	dev-java/commons-logging
	dev-java/commons-net
	=dev-java/commons-httpclient-3*
	dev-java/jsch
	dev-java/commons-collections
	dev-java/ant-core"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}"

S=${WORKDIR}/${P}-src

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/1.0-noget.patch"
	java-ant_rewrite-classpath
	java-ant_ignore-system-classes
}

EANT_GENTOO_CLASSPATH="
	commons-logging
	commons-net
	commons-httpclient-3
	jsch
	commons-collections
	ant-core
"
EANT_EXTRA_ARGS="-Dlibdir=${T}"

# The build.xml is generated from maven and can't run the tests properly
# Use maven test to execute these manually but that means downloading deps from
# the internet. Also the tests need to login to some ftp servers and samba
# shares so I doubt they work for everyone.
#src_test() {
#	ANT_TASKS="ant-junit" eant test
#}

src_install() {
	java-pkg_newjar target/*.jar
	dodoc *.txt || die
	use doc && java-pkg_dojavadoc ./dist/docs/api
	use source && java-pkg_dosrc ./core/src/main/java
}
