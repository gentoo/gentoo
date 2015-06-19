# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/javacc/javacc-4.0-r4.ebuild,v 1.8 2011/08/12 16:02:22 xarthisius Exp $

IUSE="doc examples source test"

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="Java Compiler Compiler - The Java Parser Generator"
HOMEPAGE="https://javacc.dev.java.net/"
SRC_URI="https://${PN}.dev.java.net/files/documents/17/26783/${P}src.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd"
DEPEND=">=virtual/jdk-1.4
	=dev-java/junit-3.8*
	test? ( dev-java/ant-junit )"
RDEPEND=">=virtual/jre-1.4
	=dev-java/junit-3.8*"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-javadoc.patch
	rm -v lib/junit*/*.jar || die
}

_eant() {
	# Most likely not needed at runtime but better safe than sorry
	eant -Djunit.jar="$(java-pkg_getjar junit junit.jar)" "${@}"
}

src_compile() {
	_eant jar $(use_doc)
}

src_test() {
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

	echo "export VERSION=4.0" > "${T}"/pre

	local launcher
	for launcher in javacc jjdoc jjtree
	do
		java-pkg_dolauncher ${launcher} -pre "${T}"/pre --main ${launcher}
	done
}
