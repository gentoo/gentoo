# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="net.java.dev.msv:xsdlib:2013.6.1"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Sun XML Datatypes Library"
HOMEPAGE="http://msv.java.net/"
SRC_URI="https://repo1.maven.org/maven2/net/java/dev/msv/xsdlib/${PV}/xsdlib-${PV}-sources.jar"

LICENSE="BSD Apache-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

CP_DEPEND="dev-java/relaxng-datatype:0"
BDEPEND="app-arch/unzip"
RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"
DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"

S="${WORKDIR}"

JAVA_RESOURCE_DIRS="resources"

src_prepare() {
	default
	mkdir resources || die
	cp -r com resources || die
	find "${JAVA_RESOURCE_DIRS}" -type f ! -name '*.properties' -exec rm -rf {} + || die
}
