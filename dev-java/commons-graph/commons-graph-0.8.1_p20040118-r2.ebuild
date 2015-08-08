# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2 eutils
MY_PN=graph2
MY_PV=${PV%%_*}.cvs${PV##*_p}
MY_P=${MY_PN}-${MY_PV}
API_PV=${PV%%_*}
DESCRIPTION="A toolkit for managing graphs and graph based data structures"
# There doesn't seem to be a real home page, so we'll point to a viewcvs
HOMEPAGE="http://cvs.apache.org/viewcvs/jakarta-commons-sandbox/graph2/"
# this was extracted from a source rpm at jpackage
SRC_URI="mirror://gentoo/distfiles/${MY_P}.tar.gz"
COMMON_DEP="
	dev-java/commons-collections
	dev-java/jdepend"
DEPEND=">=virtual/jdk-1.3
	test? ( dev-java/ant-junit )
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.3
	${COMMON_DEP}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
S=${WORKDIR}/${MY_P}

src_unpack(){
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-gentoo.diff"
	mkdir -p target/lib
	cd target/lib
	java-pkg_jar-from commons-collections
	java-pkg_jar-from jdepend
}

src_install(){
	java-pkg_newjar target/${PN}-${API_PV}.jar ${PN}.jar
	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/java/*
}

src_test() {
	cd "${S}/target/lib"
	java-pkg_jar-from junit
	cd "${S}"
	ANT_TASKS="ant-junit" eant test
}
