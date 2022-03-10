# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="${PV:4:2}.${PV:6}"
MY_PV="${PV:0:4}.${MY_PV//0}"
JAVA_PKG_IUSE="doc source"
MAVEN_ID="net.java.dev.msv:msv-core:2013.6.1"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Multi-Schema XML Validator, a Java tool for validating XML documents"
HOMEPAGE="https://msv.java.net/"
SRC_URI="https://search.maven.org/remotecontent?filepath=net/java/dev/${PN}/${PN}-core/${MY_PV}/${PN}-core-${MY_PV}-sources.jar"

LICENSE="BSD Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

CP_DEPEND="
	dev-java/iso-relax:0
	dev-java/relaxng-datatype:0
	dev-java/xml-commons-resolver:0
	dev-java/xsdlib:0"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"

RDEPEND="${CP_DEPEND}
	dev-java/xerces:2
	>=virtual/jre-1.8:*"

BDEPEND="app-arch/unzip"

JAVAC_ARGS="-XDignore.symbol.file"
JAVA_SRC_DIR="."
JAVA_RESOURCE_DIRS="res"

src_prepare() {
	default
	mkdir "res" || die
	cp -r "com" "res" || die

	# The only resources to have are '*.properties'
	find res -type f ! -name '*.properties' -exec rm -rf {} + || die

	sed -e '/resolver.tools.CatalogResolver/s/com.sun.org.apache.xml.internal/org.apache.xml/' \
		-i com/sun/msv/driver/textui/Driver.java || die
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_register-dependency xerces-2
	java-pkg_dolauncher "${PN}" --main com.sun.msv.driver.textui.Driver
}
