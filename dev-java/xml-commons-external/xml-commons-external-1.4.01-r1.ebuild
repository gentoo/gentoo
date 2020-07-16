# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PN="xml-apis"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Externally-defined set of standard interfaces, namely DOM, SAX, and JAXP"
HOMEPAGE="https://xerces.apache.org/xml-commons/components/external/"
SRC_URI="https://repo1.maven.org/maven2/${MY_PN}/${MY_PN}/${PV}/${MY_P}-sources.jar -> ${P}.jar"

LICENSE="Apache-2.0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
SLOT="1.4"
IUSE=""

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	>=virtual/jdk-1.6
	source? ( app-arch/zip )"
