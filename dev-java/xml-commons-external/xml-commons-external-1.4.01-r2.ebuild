# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PN="xml-apis"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Externally-defined set of standard interfaces, namely DOM, SAX, and JAXP"
HOMEPAGE="https://xerces.apache.org/xml-commons/components/external/"
SRC_URI="https://repo1.maven.org/maven2/${MY_PN}/${MY_PN}/${PV}/${MY_P}-sources.jar -> ${P}.jar"

LICENSE="Apache-2.0"
SLOT="1.4"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*"
BDEPEND="source? ( app-arch/zip )"
