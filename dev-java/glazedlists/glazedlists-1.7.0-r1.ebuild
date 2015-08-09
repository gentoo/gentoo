# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="A toolkit for list transformations"
HOMEPAGE="http://publicobject.com/glazedlists/"
SRC_DOCUMENT_ID_JAVA5="1073/38679"
SRC_URI="https://${PN}.dev.java.net/files/documents/${SRC_DOCUMENT_ID_JAVA5}/${P}-source_java15.zip"
LICENSE="|| ( LGPL-2.1 MPL-1.1 )"
SLOT="0"
KEYWORDS="amd64 ppc x86"
# TODO: there are extensions, some supported in the java-experimental ebuild
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip"

S="${WORKDIR}"

# tests seem to be buggy
RESTRICT="test"

# build file already has correct target version
JAVA_PKG_BSFIX="off"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# disable autodownloading of dependencies
	# sort out test targets
	epatch "${FILESDIR}/${P}-build.xml.patch"
}

EANT_DOC_TARGET="docs"

src_install() {
	java-pkg_newjar "target/${PN}_java15.jar"

	if use doc; then
		dohtml readme.html || die
		java-pkg_dojavadoc "target/docs/api"
	fi
	if use source; then
		# collect source folders for all the used extensions
		local source_folders="source/ca extensions/treetable/source/*"
		java-pkg_dosrc ${source_folders}
	fi
}
