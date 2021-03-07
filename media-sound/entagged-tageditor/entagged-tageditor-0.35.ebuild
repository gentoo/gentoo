# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop java-pkg-2 java-ant-2

DESCRIPTION="Open-source audiofile tagger"
HOMEPAGE="http://entagged.sourceforge.net/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}"

RDEPEND=">=virtual/jre-1.5
	dev-java/squareness-jlf:0
	dev-db/hsqldb:0"

DEPEND=">=virtual/jdk-1.5
	dev-db/hsqldb:0"

EANT_BUILD_XML="entagged/build.xml"
EANT_BUILD_TARGET="build"

src_prepare() {
	java-pkg-2_src_prepare
	mkdir -p test/entagged/junit || die
	mv entagged/entagged/junit test/entagged || die
	rm entagged/*.jar || die
	java-pkg_jarfrom hsqldb hsqldb.jar entagged/hsqldb.jar
	cd entagged || die
	eapply "${FILESDIR}"/${P}-buildfixes.patch
}

src_install() {
	cd entagged || die
	java-pkg_newjar ${P}.jar ${PN}.jar
	java-pkg_register-dependency squareness-jlf
	java-pkg_dolauncher ${PN} --main entagged.tageditor.TagEditorFrameSplash
	newicon entagged/tageditor/resources/icons/entagged-icon.png ${PN}.png
	make_desktop_entry ${PN} "Entagged Tag Editor" ${PN}
}
