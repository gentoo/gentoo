# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils qmake-utils xdg-utils

DESCRIPTION="Simple Qt-based XML editor"
HOMEPAGE="http://qxmledit.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tgz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtprintsupport:5
	dev-qt/qtscxml:5
	dev-qt/qtsql:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	dev-qt/qtxmlpatterns:5
	media-libs/glu
	virtual/opengl
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS NEWS README )

src_prepare() {
	default

	# bug 568746
	sed -i -e '/QMAKE_CXXFLAGS/s:-Werror::' \
		src/{QXmlEdit,QXmlEditWidget,sessions/QXmlEditSessions}.pro || die
}

src_configure() {
	export \
		QXMLEDIT_INST_DIR="${EPREFIX}/usr/bin" \
		QXMLEDIT_INST_LIB_DIR="${EPREFIX}/usr/$(get_libdir)" \
		QXMLEDIT_INST_INCLUDE_DIR="${EPREFIX}/usr/include/${PN}" \
		QXMLEDIT_INST_DATA_DIR="${EPREFIX}/usr/share/${PN}" \
		QXMLEDIT_INST_DOC_DIR="${EPREFIX}/usr/share/doc/${PF}"

	# avoid internal compiler errors
	use x86 && export QXMLEDIT_INST_AVOID_PRECOMP_HEADERS=Y

	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install

	doicon install_scripts/environment/icon/qxmledit.png
	domenu install_scripts/environment/desktop/QXmlEdit.desktop
	einstalldocs
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
