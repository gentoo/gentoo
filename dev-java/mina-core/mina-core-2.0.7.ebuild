# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

MY_P=apache-mina-${PV}

DESCRIPTION="MINA (Multipurpose Infrastructure for Network Application) core framework"
HOMEPAGE="http://mina.apache.org/"
SRC_URI="mirror://apache/mina/mina/${PV}/${MY_P}-src.tar.bz2"
KEYWORDS="~amd64 ~x86"
LICENSE="Apache-2.0"
SLOT="0"

COMMON_DEP="dev-java/slf4j-api:0"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"

S=${WORKDIR}/${MY_P}/src/${PN}

EANT_GENTOO_CLASSPATH="slf4j-api"
JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_EXTRA_ARGS="-Dmaven.build.finalName=${PN}"

java_prepare() {
	cp "${FILESDIR}"/${P}-maven-build.xml build.xml || die
}

src_install() {
	java-pkg_dojar target/${PN}.jar
	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java/*
}
