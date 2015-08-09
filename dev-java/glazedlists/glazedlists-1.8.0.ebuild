# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="A toolkit for list transformations"
HOMEPAGE="http://www.glazedlists.com/"
SRC_URI="http://java.net/downloads/${PN}/${P}/${P}-source_java15.zip"
LICENSE="|| ( LGPL-2.1 MPL-1.1 )"
SLOT="0"
KEYWORDS="amd64 x86"
# TODO: there are extensions, some supported in the java-experimental ebuild
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip"

S="${WORKDIR}"

JAVA_PKG_BSFIX="off"

# tests seem to be buggy
RESTRICT="test"

java_prepare() {
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
