# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc examples source test"
MAVAN_ID="net.java.dev.javacc:javacc:${PV}"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java Compiler Compiler - The Java Parser Generator"
HOMEPAGE="https://javacc.github.io/javacc/"
SRC_URI="https://github.com/javacc/javacc/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="7.0.4"
KEYWORDS="~amd64 ~arm ~arm64"

DEPEND="
	>=virtual/jdk-1.8:*
	test? (	>=dev-java/ant-1.10.14:0[junit] )"

RDEPEND=">=virtual/jre-1.8:*"

DOCS=(
	README
	javacc-releases.notes
	jjdoc-releases.notes
	jjtree-releases.notes
	release.notes
)

JAVA_ANT_REWRITE_CLASSPATH="yes"

src_prepare() {
	java-pkg-2_src_prepare
	java-pkg_clean ! -path "./bootstrap/*"
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar "target/${PN}.jar"

	if use doc; then
		java-pkg_dohtml -r www/*
		java-pkg_dojavadoc target/javadoc
	fi

	use examples && java-pkg_doexamples examples
	use source && java-pkg_dosrc src/*

	echo "JAVACC_HOME=${EPREFIX}/usr/share/javacc/" > "${T}"/22javacc-${SLOT} || die
	doenvd "${T}"/22javacc-${SLOT}

	echo "export VERSION=${PV}" > "${T}"/pre || die

	local launcher
	for launcher in javacc jjdoc jjtree; do
		java-pkg_dolauncher ${launcher}-${SLOT} -pre "${T}"/pre --main ${launcher}
	done

	einstalldocs
}
