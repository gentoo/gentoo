# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

JAVA_PKG_IUSE="source"
WANT_ANT_TASKS="ant-nodeps"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="A standalone implementation of JavaDoc engine suited for XDoclet"
HOMEPAGE="http://xdoclet.sourceforge.net/xjavadoc/"
SRC_URI="mirror://sourceforge/xdoclet/${P}-src.tar.gz
	mirror://gentoo/${P}-supplement.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

COMMON_DEPEND="
	dev-java/commons-collections:0
	dev-java/junit:0"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPEND}"
DEPEND=">=virtual/jdk-1.5
	dev-java/javacc
	${COMMON_DEPEND}"

java_prepare() {
	# remove the junit tests, would need xdoclet, causing circular dep
	epatch "${FILESDIR}"/${P}-nojunit.patch

	cd "${S}"/lib || die
	rm -v *.jar || die
	java-pkg_jar-from commons-collections,junit
	java-pkg_jar-from --build-only javacc
}

src_install() {
	java-pkg_dojar target/${PN}.jar
	use source && java-pkg_dosrc src/*
}
