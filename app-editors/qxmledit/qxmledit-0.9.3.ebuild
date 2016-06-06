# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils qmake-utils

DESCRIPTION="Simple Qt-based XML editor"
HOMEPAGE="http://qxmledit.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tgz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="qt5"

DEPEND="
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtprintsupport:5
		dev-qt/qtsql:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
		dev-qt/qtxmlpatterns:5
	)
	!qt5? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtsql:4
		dev-qt/qtsvg:4
		dev-qt/qtxmlpatterns:4
	)"
RDEPEND="${DEPEND}"

DOCS=(AUTHORS NEWS README)

src_prepare() {
	default

	# bug 568746
	sed -i -e '/QMAKE_CXXFLAGS/s:-Werror::' \
		src/{QXmlEdit,QXmlEditWidget,sessions/QXmlEditSessions}.pro || die
}

src_configure() {
	export \
		QXMLEDIT_INST_DIR="/usr/bin" \
		QXMLEDIT_INST_LIB_DIR="/usr/$(get_libdir)" \
		QXMLEDIT_INST_INCLUDE_DIR="/usr/include/${PN}" \
		QXMLEDIT_INST_DATA_DIR="/usr/share/${PN}" \
		QXMLEDIT_INST_DOC_DIR="/usr/share/doc/${PF}" \
		QXMLEDIT_INST_TRANSLATIONS_DIR="/usr/share/${PN}/translations"

	if use qt5; then
		eqmake5
	else
		eqmake4
	fi
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	doicon install_scripts/environment/icon/qxmledit.png
	domenu install_scripts/environment/desktop/QXmlEdit.desktop
	einstalldocs
}
