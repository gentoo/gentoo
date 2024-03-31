# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} != *9999* ]]; then
	QT5_KDEPATCHSET_REV=1
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc64 ~sparc ~x86"
fi

QT5_MODULE="qttools"
inherit desktop qt5-build xdg-utils

DESCRIPTION="Tool for viewing on-line documentation in Qt help file format"

IUSE=""

DEPEND="
	=dev-qt/qtcore-${QT5_PV}*:5=
	=dev-qt/qtgui-${QT5_PV}*[png]
	=dev-qt/qthelp-${QT5_PV}*
	=dev-qt/qtnetwork-${QT5_PV}*
	=dev-qt/qtprintsupport-${QT5_PV}*
	=dev-qt/qtsql-${QT5_PV}*[sqlite]
	=dev-qt/qtwidgets-${QT5_PV}*
"
RDEPEND="${DEPEND}
	!dev-qt/${PN}:5
	!<dev-qt/qtchooser-66-r2
"

QT5_TARGET_SUBDIRS=(
	src/assistant/assistant
)

src_prepare() {
	sed -e "s/qtHaveModule(webkitwidgets)/false/g" \
		-i src/assistant/assistant/assistant.pro || die

	qt5-build_src_prepare
}

src_install() {
	qt5-build_src_install
	qt5_symlink_binary_to_path assistant

	doicon -s 32 src/assistant/assistant/images/assistant.png
	newicon -s 128 src/assistant/assistant/images/assistant-128.png assistant.png
	make_desktop_entry "${QT5_BINDIR}"/assistant 'Qt 5 Assistant' assistant 'Qt;Development;Documentation'
}

pkg_postinst() {
	qt5-build_pkg_postinst
	xdg_icon_cache_update
}

pkg_postrm() {
	qt5-build_pkg_postrm
	xdg_icon_cache_update
}
