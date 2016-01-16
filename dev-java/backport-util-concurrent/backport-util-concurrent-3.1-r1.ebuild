# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

SF_PN="backport-jsr166"
MY_P="${PN}-Java60-${PV}"

DESCRIPTION="A portability wrapper for java.util.concurrent API (jsr166) 6.0"
HOMEPAGE="http://${SF_PN}.sourceforge.net/"
SRC_URI="mirror://sourceforge/${SF_PN}/${PV}/${MY_P}-src.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

DEPEND=">=virtual/jdk-1.6
	test? (
		dev-java/junit:0
		)
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}/${MY_P}-src"

java_prepare() {
	if use test; then
		# make test not depend on make
		epatch "${FILESDIR}/${PN}-3.0-test.patch"
	else
		# don't compile test classes
		epatch "${FILESDIR}/${PN}-3.0-notest.patch"
	fi

	cd "${S}/external" || die
	rm -v *.jar || die

	use test && java-pkg_jar-from --build-only junit
}

EANT_BUILD_TARGET="javacompile archive"
EANT_TEST_TARGET="test"

src_install() {
	java-pkg_dojar ${PN}.jar
	dohtml README.html || die

	use doc && java-pkg_dojavadoc doc/api
	use source && java-pkg_dosrc src/*
}
