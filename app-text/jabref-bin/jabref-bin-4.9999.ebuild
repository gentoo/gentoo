# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils java-pkg-2

DESCRIPTION="Java GUI manages bibliographies in a BibTeX database"
HOMEPAGE="http://www.jabref.org/"
S="${WORKDIR}"
PROPERTIES="live"

LICENSE="MIT"
SLOT="0"

DEPEND="app-arch/unzip"

RDEPEND="
	dev-java/openjdk:8[javafx]
	virtual/jre:1.8
"

src_unpack() {
	einfo "Downloading the latest Jabref development snapshot."
	einfo "Upstream updates these a few times per day."
	wget "https://builds.jabref.org/master/JabRef--master--latest.jar" -O ${P}.jar || die "wget failed"
	unzip  ${P}.jar images/external/JabRef-icon-48.png || die "icon extraction failed"
}

src_install() {
	java-pkg_newjar "${P}.jar"
	java-pkg_dolauncher "${PN}" --jar "${PN}.jar"
	newicon images/external/JabRef-icon-48.png JabRef-bin-icon.png
	make_desktop_entry "${PN}" JabRef-bin JabRef-bin-icon Office
	ewarn "Jabref 4.x will convert old 3.x format .bib databases to a new format."
	ewarn "The conversion is irreversible, backup .bib files before starting Jabref."
	ewarn "Jabref 4.x is under heavy development and very unstable."
}
