# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/argouml/argouml-0.34.ebuild,v 1.5 2012/05/06 14:05:52 ago Exp $

EAPI="3"

inherit eutils fdo-mime java-pkg-2

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
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
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

	dodoc ${P}/README.txt || die

	if use doc ; then
		dohtml -r release/{Readme.htm,www}
		insinto /usr/share/doc/${P}
		doins "${DISTDIR}/manual-${PV}.pdf"
		doins "${DISTDIR}/quickguide-${PV}.pdf"
	fi

	newicon ${P}/icon/ArgoIcon128x128.png ${PN}.png || die
	make_desktop_entry ${PN} "ArgoUML"
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
