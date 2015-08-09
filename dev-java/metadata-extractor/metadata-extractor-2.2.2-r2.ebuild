# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit java-pkg-2 java-ant-2

DESCRIPTION="Metadata extraction framework for Exif and IPTC metadata segments, extraction support for JPEG files"
HOMEPAGE="http://www.drewnoakes.com/code/exif/"
SRC_URI="http://www.drewnoakes.com/code/exif/metadata-extractor-${PV}-src.jar"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc amd64"
IUSE="test"

DEPEND="
	|| ( =virtual/jdk-1.6* =virtual/jdk-1.5* =virtual/jdk-1.4* )
	=dev-java/junit-3.8*
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.4"
S=${WORKDIR}/

src_unpack() {
	jar xf "${DISTDIR}/${A}"
	sed -e "s:clean, compile, test:clean, compile:" -i metadata-extractor.build || die "sed failed"
	mv metadata-extractor.build build.xml

	java-pkg_jar-from --build-only --into lib/ junit junit.jar
}

EANT_DOC_TARGET=""
EANT_BUILD_TARGET="dist-binaries"

src_install() {
	dodoc ReleaseNotes.txt
	java-pkg_newjar dist/*.jar "${PN}.jar"
}

src_test() {
	ANT_TASKS="ant-junit" eant test
}
