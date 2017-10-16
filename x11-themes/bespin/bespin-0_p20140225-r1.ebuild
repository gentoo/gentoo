# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils

DESCRIPTION="Very configurable Qt4 style derived from the Oxygen project"
HOMEPAGE="http://cloudcity.sourceforge.net/"
SRC_URI="https://sourceforge.net/code-snapshots/svn/c/cl/cloudcity/code/cloudcity-code-1712.zip"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/qt3support:4
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
	x11-libs/libX11
	x11-libs/libXrender
"
DEPEND="${RDEPEND}
	app-arch/unzip
"

S="${WORKDIR}/cloudcity-code-1712"

src_configure() {
	eqmake4
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}
