# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

MY_PN="${PN}-dev"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="An Open Source XMPP (Jabber) client library for instant messaging and presence"
HOMEPAGE="http://www.jivesoftware.org/smack/"
SRC_URI="http://www.jivesoftware.org/builds/${PN}/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="2.2"
KEYWORDS="amd64 x86"
IUSE=""

COMMON_DEP="dev-java/xpp3"

DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"

S="${WORKDIR}/${MY_P}"

src_unpack() {

	unpack ${A}

	cd "${S}"
	rm -f *.jar build/lib/*.jar build/merge/*.jar build/*.jar

	cd "${S}/build/lib/"
	java-pkg_jar-from xpp3

	sed -i -e '/zipfileset/d' "${S}/build/build.xml" || die

}

EANT_BUILD_XML="build/build.xml"
EANT_EXTRA_ARGS="-Djavadoc.dest.dir=api"

src_install() {

	java-pkg_dojar *.jar

	dohtml *.html

	use doc && {
		java-pkg_dohtml -r documentation/*
		java-pkg_dojavadoc api
	}
	use source && java-pkg_dosrc source/*

}
