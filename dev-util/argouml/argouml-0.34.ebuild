# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop xdg-utils java-pkg-2

DESCRIPTION="Modelling tool that helps you do your design using UML"
HOMEPAGE="http://argouml.tigris.org"
BASE_URI="http://argouml-downloads.tigris.org/nonav/${P}"
SRC_URI="${BASE_URI}/ArgoUML-${PV}.tar.gz
	http://argouml-downloads.tigris.org/nonav/argouml-db-1.0/dbuml-module-1.0.4.zip
	doc? (
		${BASE_URI}/manual-${PV}.pdf
		${BASE_URI}/quickguide-${PV}.pdf
	)"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc"

DEPEND="app-arch/unzip"
RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}"

src_compile() { :; }

src_install() {
	java-pkg_jarinto /opt/${PN}/lib
	java-pkg_dojar ${P}/*.jar

	java-pkg_jarinto /opt/${PN}/lib/ext
	java-pkg_dojar ${P}/ext/*.jar release/ext/*.jar

	java-pkg_dolauncher ${PN} --main org.argouml.application.Main

	dodoc ${P}/README.txt

	if use doc; then
		find release/ \( -name Thumbs.db -o -name filelist.xml \) \
			-delete || die
		HTML_DOCS=( release/{Readme.htm,www} )
		DOCS=(
			"${DISTDIR}"/manual-${PV}.pdf
			"${DISTDIR}"/quickguide-${PV}.pdf
		)
		einstalldocs
	fi

	newicon ${P}/icon/ArgoIcon128x128.png ${PN}.png || die
	make_desktop_entry ${PN} "ArgoUML"
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
