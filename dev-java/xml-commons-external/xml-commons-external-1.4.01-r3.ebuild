# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="xml-apis:xml-apis:1.4.01"

inherit java-pkg-2 java-pkg-simple

MY_PN="xml-apis"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Externally-defined set of standard interfaces, namely DOM, SAX, and JAXP"
HOMEPAGE="https://xerces.apache.org/xml-commons/components/external/"
SRC_URI="https://repo1.maven.org/maven2/${MY_PN}/${MY_PN}/${PV}/${MY_P}-sources.jar -> ${P}.jar"

LICENSE="Apache-2.0"
SLOT="1.4"
KEYWORDS="amd64 arm64 ppc64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

BDEPEND="source? ( app-arch/zip )"
DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

JAVADOC_ARGS="-source 8"
