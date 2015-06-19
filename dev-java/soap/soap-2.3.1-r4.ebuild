# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/soap/soap-2.3.1-r4.ebuild,v 1.3 2015/03/27 10:22:16 ago Exp $

EAPI=4

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2 versionator

DESCRIPTION="Apache SOAP (Simple Object Access Protocol) is an implementation of the SOAP submission to W3C"
HOMEPAGE="http://ws.apache.org/soap/"
SRC_URI="http://archive.apache.org/dist/ws/soap/version-${PV}/soap-src-${PV}.tar.gz"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

CDEPEND="
	java-virtuals/jaf:0
	java-virtuals/javamail:0
	java-virtuals/servlet-api:3.0"
RDEPEND="
	>=virtual/jre-1.4
	${CDEPEND}"
DEPEND="
	>=virtual/jdk-1.4
	${CDEPEND}"

S="${WORKDIR}"/${PN}-$(replace_all_version_separators _)

JAVA_PKG_FILTER_COMPILER="jikes"

java_prepare() {
	# get rid of automagical tests, add gentoo.classpath to <javac>
	epatch "${FILESDIR}/${P}-build.xml.patch"
	epatch "${FILESDIR}/${P}-java7-enum.patch"
}

EANT_GENTOO_CLASSPATH="javamail,jaf,servlet-api-3.0"
EANT_BUILD_TARGET="compile"
EANT_DOC_TARGET="javadocs"

src_install() {
	java-pkg_dojar build/lib/${PN}.jar

	java-pkg_register-optional-dependency xerces-2

	use doc && java-pkg_dojavadoc build/javadocs
	use source && java-pkg_dosrc src/org
}
