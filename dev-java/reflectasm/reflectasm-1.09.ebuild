# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/reflectasm/reflectasm-1.09.ebuild,v 1.1 2014/02/04 02:11:26 radhermit Exp $

EAPI=5
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="High performance Java reflection"
HOMEPAGE="https://github.com/EsotericSoftware/reflectasm/"
SRC_URI="https://github.com/EsotericSoftware/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

COMMON_DEPEND="dev-java/asm:4"
RDEPEND="${COMMON_DEPEND}
	>=virtual/jre-1.5"
DEPEND="${COMMON_DEPEND}
	>=virtual/jdk-1.5
	test? (
		dev-java/junit:4
		dev-java/ant-junit4:0
	)"

EANT_GENTOO_CLASSPATH="asm-4"
EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},junit-4"
JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_EXTRA_ARGS="-Dmaven.build.finalName=${PN}"

java_prepare() {
	cp "${FILESDIR}"/${P}-maven-build.xml build.xml || die
	find . -name '*.jar' -delete

	epatch "${FILESDIR}"/${P}-parallel-tests.patch
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar target/${PN}.jar
	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src
}
