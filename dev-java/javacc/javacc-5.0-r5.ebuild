# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc examples source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java Compiler Compiler - The Java Parser Generator"
HOMEPAGE="https://javacc.github.io/javacc/"
SRC_URI="http://java.net/projects/${PN}/downloads/download/${P}src.tar.gz"

LICENSE="BSD"
SLOT="0"

KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

CDEPEND="dev-java/junit:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.8:*"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.8:*
	test? (	>=dev-java/ant-1.10.14:0[junit] )"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}"/${PN}-4.0-javadoc.patch
)

JAVA_ANT_REWRITE_CLASSPATH="yes"
JAVA_ANT_CLASSPATH_TAGS+=" javadoc"

EANT_GENTOO_CLASSPATH="junit"

src_prepare() {
	default #780585

	rm -v lib/junit*/*.jar || die
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar "bin/lib/${PN}.jar"

	if use doc; then
		java-pkg_dohtml -r www/*
		java-pkg_dojavadoc doc/api
	fi

	use examples && java-pkg_doexamples examples
	use source && java-pkg_dosrc src/*

	echo "JAVACC_HOME=${EPREFIX}/usr/share/javacc/" > "${T}"/22javacc || die
	doenvd "${T}"/22javacc

	echo "export VERSION=${PV}" > "${T}"/pre || die

	local launcher
	for launcher in javacc jjdoc jjtree; do
		java-pkg_dolauncher ${launcher} -pre "${T}"/pre --main ${launcher}
	done

	einstalldocs
}
