# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

WANT_ANT_TASKS="ant-nodeps"
JAVA_PKG_IUSE="doc source test"
inherit base java-pkg-2 java-ant-2 eutils

MY_PN="wrapper"
MY_P="${MY_PN}_${PV}_src"
DESCRIPTION="A wrapper that makes it possible to install a Java Application as daemon"
HOMEPAGE="http://wrapper.tanukisoftware.org/"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.4"

# TODO test with 1.3
DEPEND=">=virtual/jdk-1.4
		test? (
			dev-java/ant-junit
			=dev-java/junit-3*
		)"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	java-pkg-2_pkg_setup

	BITS="32"
	use amd64 && BITS="64"
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# TODO file upstream
	epatch "${FILESDIR}/${P}-build.xml.patch"

	use x86 && sed -i -e 's|gcc -O3 -Wall --pedantic|$(CC) $(CFLAGS) -fPIC -lm|g' \
		"src/c/Makefile-linux-x86-${BITS}"
	use amd64 && sed -i -e 's|gcc -O3 -fPIC -Wall --pedantic|$(CC) $(CFLAGS) -fPIC|g' \
		"src/c/Makefile-linux-x86-${BITS}"
	# remove to avoid usage of stuff here"
	rm -R tools

	if use test; then
		mkdir lib
		cd lib
		java-pkg_jar-from --build-only junit
	fi
}

src_compile() {
	tc-getCC
	eant -Dbits=${BITS} jar compile-c $(use_doc -Djdoc.dir=api jdoc)
}

src_test() {
	ANT_TASKS="ant-junit ant-nodeps" eant -Dbits="${BITS}" test
}

src_install() {
	java-pkg_dojar lib/wrapper.jar
	java-pkg_doso lib/libwrapper.so

	dobin bin/wrapper
	dodoc doc/{AUTHORS,readme.txt,revisions.txt}

	use doc && dohtml -r doc/english/
	use doc && java-pkg_dojavadoc api
	use source && java-pkg_dosrc src/java/*
}
