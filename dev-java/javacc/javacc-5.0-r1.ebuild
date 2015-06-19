# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/javacc/javacc-5.0-r1.ebuild,v 1.5 2015/05/17 20:05:58 pacho Exp $

EAPI="4"

JAVA_PKG_IUSE="doc examples source test"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Java Compiler Compiler - The Java Parser Generator"
HOMEPAGE="https://javacc.java.net/"
SRC_URI="http://java.net/projects/${PN}/downloads/download/${P}src.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

COMMON_DEP="
	dev-java/junit:0"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.5"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.5
	test? (	dev-java/ant-junit:0 )"

S="${WORKDIR}/${PN}"

java_prepare() {
	epatch "${FILESDIR}"/${PN}-4.0-javadoc.patch
	rm -v lib/junit*/*.jar || die
}

JAVA_ANT_REWRITE_CLASSPATH="yes"
JAVA_ANT_CLASSPATH_TAGS+=" javadoc"

EANT_GENTOO_CLASSPATH="junit"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar bin/lib/${PN}.jar

	dodoc README

	if use doc; then
		java-pkg_dohtml -r www/*
		java-pkg_dojavadoc doc/api
	fi
	use examples && java-pkg_doexamples examples
	use source && java-pkg_dosrc src/*

	echo "JAVACC_HOME=${EPREFIX}/usr/share/javacc/" > "${T}"/22javacc
	doenvd "${T}"/22javacc

	echo "export VERSION=${PV}" > "${T}"/pre

	local launcher
	for launcher in javacc jjdoc jjtree
	do
		java-pkg_dolauncher ${launcher} -pre "${T}"/pre --main ${launcher}
	done
}
