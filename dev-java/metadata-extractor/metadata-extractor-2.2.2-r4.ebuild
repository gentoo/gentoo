# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="Metadata extraction framework for Exif and IPTC metadata segments, extraction support for JPEG files"
HOMEPAGE="http://www.drewnoakes.com/code/exif/"
SRC_URI="http://www.drewnoakes.com/code/exif/metadata-extractor-${PV}-src.jar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE="test"

DEPEND="|| ( =virtual/jdk-1.6* =virtual/jdk-1.5* =virtual/jdk-1.4* )
	test? ( dev-java/junit:0 )
	app-arch/unzip:0"

RDEPEND=">=virtual/jre-1.4"
S=${WORKDIR}

java_prepare() {
	epatch "${FILESDIR}"/${P}-buildfix.patch

	mv metadata-extractor.build build.xml || die

	use test && java-pkg_jar-from --build-only --into lib/ junit junit.jar
}

EANT_DOC_TARGET=""
EANT_BUILD_TARGET="dist-binaries"

src_install() {
	java-pkg_newjar dist/*.jar ${PN}.jar

	dodoc ReleaseNotes.txt
}

src_test() {
	ANT_TASKS="ant-junit" eant test
}
