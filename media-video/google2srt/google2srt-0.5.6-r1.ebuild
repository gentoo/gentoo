# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

MY_PN="Google2SRT"
MY_P="${MY_PN}-${PV}"
MAINCLASS="GUI"

DESCRIPTION="Convert subtitles from Google Video and YouTube to SubRip (.srt) format"
HOMEPAGE="http://google2srt.sourceforge.net/en/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip
	http://sbriesen.de/gentoo/distfiles/google2srt-icon.png"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="html"

COMMON_DEP="dev-java/jdom:0"

RDEPEND=">=virtual/jre-1.6
	${COMMON_DEP}"

DEPEND=">=virtual/jdk-1.6
	${COMMON_DEP}"

S="${WORKDIR}/${MY_P}"

java_prepare() {
	# copy build.xml
	cp -f "${FILESDIR}/build.xml" build.xml || die

	# move resources
	mkdir -p "resources"
	mv -f src/*.{jpg,properties} "resources/"

	# update library packages
	cd lib
	rm -f jdom.jar ../${MY_PN}.jar || die
	java-pkg_jar-from jdom
	java-pkg_ensure-no-bundled-jars
}

src_compile() {
	eant build $(use_doc)
}

src_install() {
	java-pkg_dojar dist/${MY_PN}.jar
	java-pkg_dolauncher ${MY_PN} --main ${MAINCLASS} --java_args -Xmx256m
	newicon "${DISTDIR}/${PN}-icon.png" "${MY_PN}.png"
	make_desktop_entry ${MY_PN} ${MY_PN} ${MY_PN}
	use doc && java-pkg_dojavadoc apidocs
	use source && java-pkg_dosrc src
	use html && dohtml -r doc
	newdoc Changelog.txt ChangeLog
	newdoc README.TXT README
}
