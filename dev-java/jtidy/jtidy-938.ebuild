# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="net.sf.jtidy:jtidy:r${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="a Java port of HTML Tidy, a HTML syntax checker and pretty printer"
HOMEPAGE="https://sourceforge.net/projects/jtidy/"
SRC_URI="https://master.dl.sourceforge.net/project/jtidy/JTidy/r${PV}/jtidy-r${PV}-sources.zip"

LICENSE="HTML-Tidy W3C"
SLOT="9"
KEYWORDS="amd64"

BDEPEND="app-arch/unzip"
CP_DEPEND="dev-java/ant-core:0"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8 "
RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8"

JAVA_MAIN_CLASS="org.w3c.tidy.Tidy"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
