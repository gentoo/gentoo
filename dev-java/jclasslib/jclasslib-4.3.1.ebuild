# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java bytecode viewer"
HOMEPAGE="https://github.com/ingokegel/jclasslib"
JAV="24.1.0"
SRC_URI="https://github.com/ingokegel/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://repo1.maven.org/maven2/org/jetbrains/annotations/${JAV}/annotations-${JAV}.jar"
S="${WORKDIR}/${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_GENTOO_CLASSPATH_EXTRA="lib-compile/i4jruntime.jar"
JAVA_GENTOO_CLASSPATH_EXTRA+=":${DISTDIR}/annotations-${JAV}.jar"
JAVA_MAIN_CLASS="org.gjt.jclasslib.browser.BrowserApplication"
JAVA_RESOURCE_DIRS=( modules/browser/src/main/resources )
JAVA_SRC_DIR=( modules/{data,browser}/src/main/java )

src_install() {
	java-pkg-simple_src_install
	java-pkg_dojar lib-compile/i4jruntime.jar
}

pkg_postinst() {
	elog "jclasslib uses Firefox by default."
	elog "Set the BROWSER environment at your discretion."
}
