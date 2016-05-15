# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

JMI_ZIP="jmi-${PV/./_}-fr-interfaces.zip"
MOF_XML="mof-${PV}.xml.bz2"

DESCRIPTION="Java Metadata Interface Sample Class Interface"
HOMEPAGE="http://java.sun.com/products/jmi/"
SRC_URI="mirror://gentoo/${JMI_ZIP}
		 mirror://gentoo/${MOF_XML}"

LICENSE="sun-bcla-jmi"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	>=virtual/jdk-1.6
	source? ( app-arch/zip )"

JAVA_SRC_DIR="src"

src_unpack() {
	mkdir "${S}/src" || die
	cd "${S}/src" || die
	unpack ${JMI_ZIP}

	# adding mof.xml required by Netbeans 
	# #98603 and #162328
	cd "${S}/src/javax/jmi/model" || die
	unpack ${MOF_XML}
	cp mof-1.0.xml mof.xml || die
}

java_prepare() {
	# rename enum keywords because javadoc hates them
	# even with -source 1.4, bummer
	epatch "${FILESDIR}/${P}-enum.patch"
}

src_compile() {
	java-pkg-simple_src_compile
	java-pkg_addres "${PN}.jar" src -name "*.xml"
}
