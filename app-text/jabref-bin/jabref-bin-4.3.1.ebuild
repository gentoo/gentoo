# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_WANT_TARGET=1.8

inherit desktop java-pkg-2

MY_PV_1="${PV/_beta/b}"
MY_PV="${MY_PV_1/_rc/}"
MY_URI_PV_1="${PV/rc/}"
MY_URI_PV="${MY_URI_PV_1//_/%20}"

DESCRIPTION="Java GUI for managing BibTeX and other bibliographies"
HOMEPAGE="http://www.jabref.org/"
SRC_URI="https://github.com/JabRef/jabref/releases/download/v${PV}/JabRef-${MY_PV}.jar"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/unzip"

RDEPEND="
	dev-java/openjdk:8[javafx]
	virtual/jre:1.8
"

S="${WORKDIR}"

src_unpack() {
	cp -v "${DISTDIR}/${A}" . || die
	unzip ${A} images/external/JabRef-icon-128.png || die
}

src_install() {
	java-pkg_newjar "JabRef-${MY_PV}.jar"
	java-pkg_dolauncher "${PN}" --jar "${PN}.jar"
	newicon images/external/JabRef-icon-128.png JabRef-bin-icon.png
	make_desktop_entry "${PN}" JabRef-bin JabRef-bin-icon Office
	ewarn "Jabref 4.x will convert old 3.x format .bib databases to a new format."
	ewarn "The conversion is irreversible, backup .bib files before starting Jabref."
	ewarn "Jabref 4.x is under heavy development and very unstable."
}
