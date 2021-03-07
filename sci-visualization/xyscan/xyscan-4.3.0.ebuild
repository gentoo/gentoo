# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV=$(ver_rs 2 '')
inherit desktop qmake-utils

DESCRIPTION="Tool for extracting data points from graphs"
HOMEPAGE="http://rhig.physics.yale.edu/~ullrich/software/xyscan/"
SRC_URI="http://rhig.physics.yale.edu/~ullrich/software/${PN}/Distributions/${MY_PV}/${PN}-${MY_PV}-src.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	app-text/poppler[qt5]
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	default
	sed -i \
		-e "s:qApp->applicationDirPath() + \"/../docs\":\"${EPREFIX}/usr/share/doc/${PF}/html\":" \
		src/xyscanWindow.cpp || die "Failed to fix docs path"
}

src_configure() {
	eqmake5
}

src_install() {
	dobin xyscan
	local HTML_DOCS=( docs/. )
	einstalldocs
	newicon images/xyscanIcon.png xyscan.png
	make_desktop_entry xyscan "xyscan data point extractor"
}
