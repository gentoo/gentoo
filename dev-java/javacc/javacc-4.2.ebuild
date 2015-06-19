# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/javacc/javacc-4.2.ebuild,v 1.6 2012/05/12 03:17:50 aballier Exp $

EAPI="2"
JAVA_PKG_IUSE="doc examples source test"

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="Java Compiler Compiler - The Java Parser Generator"
HOMEPAGE="https://javacc.dev.java.net/"
SRC_URI="https://${PN}.dev.java.net/files/documents/17/117795/${P}src.tar.gz"
LICENSE="BSD"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~ppc ~ppc64 x86 ~amd64-fbsd ~x86-fbsd"
DEPEND=">=virtual/jdk-1.5
	dev-java/junit:0
	test? (
		>=virtual/jdk-1.5
		dev-java/ant-junit
	)
	!test? ( >=virtual/jdk-1.4 )"
RDEPEND=">=virtual/jre-1.4
	dev-java/junit:0"

# We don't want 1.5 bytecode just because of the testcase
JAVA_PKG_WANT_TARGET="1.4"
JAVA_PKG_WANT_SOURCE="1.4"

S="${WORKDIR}/${PN}"

java_prepare() {
	epatch "${FILESDIR}"/${PN}-4.0-javadoc.patch
	rm -v lib/junit*/*.jar || die
}

_eant() {
	eant -Djunit.jar="$(java-pkg_getjar --build-only junit junit.jar)" "${@}"
}

src_compile() {
	_eant jar $(use_doc)
}

src_test() {
	# this testcase wants 1.5 and this seems the easiest way to do it
	JAVA_PKG_WANT_SOURCE="1.5" JAVA_PKG_WANT_TARGET="1.5" java-ant_bsfix_one examples/JavaGrammars/1.5/build.xml
	ANT_TASKS="ant-junit" _eant test
}

src_install() {
	java-pkg_dojar bin/lib/${PN}.jar

	dodoc README || die

	if use doc; then
		java-pkg_dohtml -r www/*
		java-pkg_dojavadoc doc/api
	fi
	if use examples; then
		dodir /usr/share/doc/${PF}/examples
		cp -R examples/* "${D}"/usr/share/doc/${PF}/examples
	fi
	use source && java-pkg_dosrc src/*

	echo "JAVACC_HOME=/usr/share/javacc/" > "${T}"/22javacc
	doenvd "${T}"/22javacc

	echo "export VERSION=${PV}" > "${T}"/pre

	local launcher
	for launcher in javacc jjdoc jjtree
	do
		java-pkg_dolauncher ${launcher} -pre "${T}"/pre --main ${launcher}
	done
}
