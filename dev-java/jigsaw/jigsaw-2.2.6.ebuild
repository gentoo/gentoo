# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jigsaw/jigsaw-2.2.6.ebuild,v 1.1 2012/02/23 20:28:22 nelchael Exp $

EAPI=4

JAVA_PKG_IUSE="doc source"

# Jigsaw is actually a WWW server, it would be nice to package it as such, not
# as a raw library like this ebuild does.

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="W3 Consortium's Java-based Web server libraries"
HOMEPAGE="http://jigsaw.w3.org/"
SRC_URI="http://jigsaw.w3.org/Distrib/${PN}_${PV}.tar.bz2"

LICENSE="W3C"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

COMMON_DEP="dev-java/jakarta-oro:2.0
	java-virtuals/servlet-api:2.3
	dev-java/xerces:2
	dev-java/jtidy"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${COMMON_DEP}"

EANT_DOC_TARGET="javadocs"

S="${WORKDIR}/Jigsaw"

src_prepare() {
	rm -f classes/*.jar
	mkdir -p "${S}/jars" || die "mkdir failed"

	epatch "${FILESDIR}/${P}-build.xml.patch"

	java-pkg_jar-from --into jars/ jakarta-oro-2.0
	java-pkg_jar-from --into jars/ servlet-api-2.3
	java-pkg_jar-from --into jars/ xerces-2
	java-pkg_jar-from --into jars/ jtidy

	cd jars/
	ln -s $(java-config --tools)
}

src_install() {
	java-pkg_dojar classes/jigsaw.jar
	java-pkg_dojar classes/jigadmin.jar
	java-pkg_dojar classes/jigedit.jar

	use doc && java-pkg_dojavadoc ant.build/javadocs

	dodoc ANNOUNCE README
}
