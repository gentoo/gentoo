# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
JAVA_PKG_IUSE="source test"
inherit java-pkg-2 java-ant-2

DESCRIPTION="JvYAMLb, YAML processor extracted from JRuby"
HOMEPAGE="https://github.com/olabini/jvyamlb"
SRC_URI="https://jvyamlb.googlecode.com/files/jvyamlb-src-${PV}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

CDEPEND="dev-java/bytelist:0
	dev-java/jcodings:0
	dev-java/joda-time:0"

RDEPEND=">=virtual/jre-1.4
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.4
	test? ( dev-java/ant-junit )
	${CDEPEND}"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="bytelist jcodings joda-time"

java_prepare() {
	rm -fv lib/*.jar || die

	# Don't do tests unnecessarily.
	sed -i 's:depends="test":depends="compile":' build.xml
}

src_install() {
	java-pkg_newjar lib/${P}.jar
	use source && java-pkg_dosrc src/*
	dodoc CREDITS README || die
}

src_test() {
	ANT_TASKS="ant-junit" eant test
}
