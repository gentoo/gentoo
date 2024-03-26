# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} != *9999* ]]; then
	QT5_KDEPATCHSET_REV=1
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc64 ~sparc ~x86"
fi

QT5_MODULE="qttools"
inherit desktop qt5-build xdg-utils

DESCRIPTION="Graphical tool that lets you introspect D-Bus objects and messages"

IUSE=""

DEPEND="
	=dev-qt/qtcore-${QT5_PV}*
	=dev-qt/qtdbus-${QT5_PV}*
	=dev-qt/qtgui-${QT5_PV}*
	=dev-qt/qtwidgets-${QT5_PV}*
	=dev-qt/qtxml-${QT5_PV}*
"
RDEPEND="${DEPEND}
	!dev-qt/${PN}:5
	!<dev-qt/qtchooser-66-r2
"

QT5_TARGET_SUBDIRS=(
	src/qdbus/qdbusviewer
)

src_install() {
	qt5-build_src_install
	qt5_symlink_binary_to_path qdbusviewer

	doicon -s 32 src/qdbus/qdbusviewer/images/qdbusviewer.png
	newicon -s 128 src/qdbus/qdbusviewer/images/qdbusviewer-128.png qdbusviewer.png
	make_desktop_entry "${QT5_BINDIR}"/qdbusviewer 'Qt 5 QDBusViewer' qdbusviewer 'Qt;Development'
}

pkg_postinst() {
	qt5-build_pkg_postinst
	xdg_icon_cache_update
}

pkg_postrm() {
	qt5-build_pkg_postrm
	xdg_icon_cache_update
}
