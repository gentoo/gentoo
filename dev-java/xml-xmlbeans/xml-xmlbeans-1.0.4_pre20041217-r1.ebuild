# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

MY_P="${PN}-20041217"

DESCRIPTION="An XML-Java binding tool"
HOMEPAGE="http://xmlbeans.apache.org/"
SRC_URI="mirror://gentoo/${MY_P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="~amd64 ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

COMMON_DEPEND="
	dev-java/jaxen:1.1
	dev-java/ant-core:0"
RDEPEND="${COMMON_DEPEND}
	>=virtual/jre-1.4"
DEPEND="${COMMON_DEPEND}
	>=virtual/jdk-1.4"

S="${WORKDIR}/${MY_P}/v1"

java_prepare() {
	epatch "${FILESDIR}/xml-xmlbeans-gentoo.patch"
	java-ant_rewrite-classpath build.xml

	cd "${S}"/external/lib
	#TODO: includes and old copy named oldxbean.jar
	#that probably should not be used
	#rm -v *.jar

	java-pkg_jar-from jaxen-1.1 jaxen.jar jaxen-1.1-beta-2.jar
	java-pkg_filter-compiler jikes
}

src_compile() {
	eant xbean.jar $(use_doc docs) \
		-Dgentoo.classpath=$(java-pkg_getjars ant-core)
}

# Tests always seem to fail #100895

src_install() {
	java-pkg_dojar build/lib/xbean*.jar

	dodoc CHANGES.txt NOTICE.txt README.txt
	if use doc; then
		java-pkg_dojavadoc build/docs/reference
		java-pkg_dohtml -r docs
	fi
	use source && java-pkg_dosrc src/*
}
