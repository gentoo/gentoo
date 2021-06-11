# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
JAVA_PKG_IUSE="source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="JvYAMLb, YAML processor extracted from JRuby"
HOMEPAGE="https://github.com/olabini/jvyamlb"
SRC_URI="https://github.com/olabini/jvyamlb/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~x86-solaris"

CDEPEND="
	dev-java/bytelist:0
	dev-java/jcodings:1
	dev-java/joda-time:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.8:*"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.8:*
	test? ( dev-java/ant-junit )"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="bytelist jcodings-1 joda-time"

DOCS=( CREDITS README )

src_prepare() {
	default

	java-pkg_clean

	sed -i 's:depends="test":depends="compile":' build.xml || die
}

src_install() {
	einstalldocs
	java-pkg_newjar lib/${P}.jar
	use source && java-pkg_dosrc src/*
}

src_test() {
	ANT_TASKS="ant-junit" eant test
}
