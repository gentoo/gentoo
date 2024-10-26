# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc examples source test"
MAVEN_ID="net.java.dev.javacc:javacc:${PV}"

inherit java-pkg-2

DESCRIPTION="Java Compiler Compiler - The Java Parser Generator"
HOMEPAGE="https://javacc.github.io/javacc/"
SRC_URI="https://github.com/javacc/javacc/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="BSD-2"
SLOT="7.0.13"
KEYWORDS="amd64 arm64 ppc64"

BDEPEND=">=dev-java/ant-1.10.14:0[junit]"
DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

DOCS=(
	README.md
	docs/faq.md
	docs/release-notes.md
)

PATCHES=(
	"${FILESDIR}/javacc-7.0.13-javadoc.patch"
	"${FILESDIR}/javacc-7.0.13-source8.patch"
)

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
	java-pkg_clean ! -path "./bootstrap/*"
}

src_compile() {
	eant -Dant.build.javac.source="8" -Dant.build.javac.target="8"
	use doc && eant javadoc -Dant.build.javac.source="8" -Dant.build.javac.target="8"
}

src_test() {
	eant test -Dant.build.javac.source="8" -Dant.build.javac.target="8"
}

src_install() {
	java-pkg_dojar "target/${PN}.jar"

	use doc && java-pkg_dojavadoc target/javadoc

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
