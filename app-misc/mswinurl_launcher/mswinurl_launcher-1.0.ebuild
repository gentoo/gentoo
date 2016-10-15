# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit eutils fdo-mime python-r1

GIST_STRING="77635-a46707715aa2e112d2ea5ec26771030ff5e7eb64"

DESCRIPTION="Launcher and desktop association for MS Windows *.URL (text/x-uri) files"
HOMEPAGE="https://gist.github.com/endolith/77635"
SRC_URI="https://gist.github.com/endolith/${GIST_STRING/-//archive/}.tar.gz -> ${P}.tar.gz"

RESTRICT="mirror"
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-util/desktop-file-utils"
RDEPEND="${PYTHON_DEPS}"

S="${WORKDIR}"/$GIST_STRING

src_install() {
	dobin ${PN}.py
	python_replicate_script "${ED%/}"/usr/bin/${PN}.py

	cat <<DESKTOP_EOF >"${T}"/${PN}.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=MS Windows URL file launcher
Comment=Python script to parse and launch .url files (html links) from MS Windows
NoDisplay=true
Terminal=false
TryExec=mswinurl_launcher.py
Exec=mswinurl_launcher.py %F
Icon=text-html
MimeType=text/x-uri;
DESKTOP_EOF
	domenu "${T}"/${PN}.desktop
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
