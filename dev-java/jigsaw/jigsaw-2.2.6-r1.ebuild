# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

# Jigsaw is actually a WWW server, it would be nice to package it as such, not
# as a raw library like this ebuild does.

inherit java-pkg-2 java-ant-2

DESCRIPTION="W3 Consortium's Java-based Web server libraries"
HOMEPAGE="http://jigsaw.w3.org/"
SRC_URI="http://jigsaw.w3.org/Distrib/${PN}_${PV}.tar.bz2"

LICENSE="W3C"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

CDEPEND="
	dev-java/jtidy:0
	dev-java/xerces:2
	dev-java/jakarta-oro:2.0
	java-virtuals/servlet-api:2.3"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	app-arch/unzip
	>=virtual/jdk-1.6"

EANT_DOC_TARGET="javadocs"

S="${WORKDIR}/Jigsaw"

PATCHES=(
	"${FILESDIR}/${P}-build.xml.patch"
)

java_prepare() {
	epatch "${PATCHES[@]}"

	java-pkg_clean

	mkdir -p "${S}/jars" || die "mkdir failed"

	java-pkg_jar-from --into jars/ jakarta-oro-2.0
	java-pkg_jar-from --into jars/ servlet-api-2.3
	java-pkg_jar-from --into jars/ xerces-2
	java-pkg_jar-from --into jars/ jtidy

	cd "${S}/jars" || die
	ln -s $(java-config --tools) || die
}

src_install() {
	java-pkg_dojar classes/{jigsaw,jigadmin,jigedit}.jar

	dodoc ANNOUNCE README
	use doc && java-pkg_dojavadoc ant.build/javadocs
}
