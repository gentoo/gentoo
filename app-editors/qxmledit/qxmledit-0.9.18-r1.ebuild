# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop qmake-utils xdg

DESCRIPTION="Simple Qt-based XML editor"
HOMEPAGE="https://qxmledit.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tgz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

DEPEND="
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5[jpeg]
	dev-qt/qtimageformats:5[mng]
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
BDEPEND="dev-qt/linguist-tools:5"

DOCS=( AUTHORS NEWS README )

src_configure() {
	export \
		QXMLEDIT_INST_DIR="${EPREFIX}/usr/bin" \
		QXMLEDIT_INST_LIB_DIR="${EPREFIX}/usr/$(get_libdir)" \
		QXMLEDIT_INST_INCLUDE_DIR="${EPREFIX}/usr/include/${PN}" \
		QXMLEDIT_INST_DATA_DIR="${EPREFIX}/usr/share/${PN}" \
		QXMLEDIT_INST_DOC_DIR="${EPREFIX}/usr/share/doc/${PF}"

	# avoid -Werror (affecting src/coptions.pri) bug #925324
	export QXMLEDIT_INST_DISABLE_COMPILE_WARNINGS=Y

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
