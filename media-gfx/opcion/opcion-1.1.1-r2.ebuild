# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils java-pkg-2

MY_P="Opcion_v${PV}"

DESCRIPTION="Free font viewer written in Java"
HOMEPAGE="http://opcion.sourceforge.net/"
SRC_URI="mirror://sourceforge/opcion/${MY_P}_src.zip"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""
COMMON_DEP="=dev-java/jgoodies-looks-1.2*"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}
	app-arch/unzip"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# add missing constructor
	epatch "${FILESDIR}/${P}-fix-source.patch"

	# calls nonexisting constructor and seems unused
	rm FontViewer/windows/test.java || die

	rm -rf com/jgoodies || die
	find . -name '*.class' -delete || die
	rm *.txt || die
}

src_compile() {
	find . -name '*.java' > "${T}/src.list"
	local cp="$(java-pkg_getjars jgoodies-looks-1.2)"
	mkdir build || die
	# quite icky way to copy resources
	cp -R FontViewer com build || die
	find build -name '*.java' -delete
	ejavac -nowarn -classpath "${cp}" -d build "@${T}/src.list"
	jar cf ${PN}.jar -C build . || die
}

src_install() {
	java-pkg_dojar ${PN}.jar

	java-pkg_dolauncher ${PN} --main FontViewer.Opcion

	newicon FontViewer/resources/icons/IconSmall.png ${PN}-icon.png
	make_desktop_entry ${PN} opcion ${PN}-icon
}
