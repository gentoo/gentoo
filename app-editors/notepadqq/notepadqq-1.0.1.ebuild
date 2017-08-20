# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils

CM_PV="5.18.2"

DESCRIPTION="Notepad++-like editor for Linux"
HOMEPAGE="http://notepadqq.altervista.org"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/${PN}/CodeMirror/archive/${CM_PV}.tar.gz -> CodeMirror-${CM_PV}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	rmdir "${S}"/src/editor/libs/codemirror || die
	mv "${WORKDIR}"/CodeMirror-${CM_PV} "${S}"/src/editor/libs/codemirror \
		|| die
}

src_prepare() {
	default

	# codemirror releases have no m4 directory
	sed '/mode\/m4/d' -i src/editor/libs/Makefile-codemirror || die

	# Silence a QA warning
	sed '/^OnlyShowIn/d' \
		-i support_files/shortcuts/notepadqq.desktop \
		|| die
}

src_configure() {
	eqmake5 PREFIX="${EPREFIX}/usr" ${PN}.pro
}

src_install() {
	emake -j1 INSTALL_ROOT="${D}" install
}
