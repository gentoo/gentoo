# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="source test"
inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="Java YAML parser and emitter"
HOMEPAGE="https://jvyaml.dev.java.net/"
SRC_URI="https://${PN}.dev.java.net/files/documents/5215/41455/${PN}-src-${PV}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=virtual/jdk-1.4
	test? (
		dev-java/ant-junit
		=dev-java/junit-3*
	)"
RDEPEND=">=virtual/jre-1.4"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# https://jvyaml.dev.java.net/issues/show_bug.cgi?id=6
	epatch "${FILESDIR}/${PN}-0.2-tests.patch"

	# https://jvyaml.dev.java.net/issues/show_bug.cgi?id=5
	epatch "${FILESDIR}/${P}-tests.patch"

	cd lib
	rm -v *.jar || die
	use test && java-pkg_jar-from --build-only junit
}

#no javadoc target

src_install() {
	java-pkg_dojar lib/${PN}.jar
	dodoc README CREDITS || die
	use source && java-pkg_dosrc src/*
}

src_test() {
	ANT_TASKS="ant-junit" eant test
}
