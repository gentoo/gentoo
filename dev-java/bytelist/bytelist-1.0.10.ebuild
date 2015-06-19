# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/bytelist/bytelist-1.0.10.ebuild,v 1.4 2013/08/28 11:15:36 ago Exp $

EAPI="5"

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="JRuby support library"
HOMEPAGE="http://jruby.codehaus.org/"
SRC_URI="https://github.com/jruby/${PN}/tarball/${PV} -> ${P}.tar.gz"

LICENSE="|| ( CPL-1.0 GPL-2 LGPL-2.1 )"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~x86-solaris"

COMMON_DEP="dev-java/jcodings:0"

RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.5"

DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.5
	test? ( dev-java/ant-junit:0 )"

src_unpack() {
	default
	mv "${WORKDIR}"/jruby-${PN}-* "${WORKDIR}"/${P} || die
}

java_prepare() {
	cp "${FILESDIR}"/maven-build.xml build.xml || die
}

JAVA_ANT_REWRITE_CLASSPATH="true"

EANT_GENTOO_CLASSPATH="jcodings"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar target/${PN}.jar

	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/*
}
