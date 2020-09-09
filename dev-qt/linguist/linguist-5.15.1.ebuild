# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
QT5_MODULE="qttools"
inherit desktop qt5-build xdg-utils

DESCRIPTION="Graphical tool for translating Qt applications"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc64 ~x86"
fi

IUSE=""

DEPEND="
	~dev-qt/designer-${PV}
	~dev-qt/qtcore-${PV}:5=
	~dev-qt/qtgui-${PV}:5=
	~dev-qt/qtprintsupport-${PV}
	~dev-qt/qtwidgets-${PV}
	~dev-qt/qtxml-${PV}
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/linguist/linguist
)

src_install() {
	qt5-build_src_install

	local size
	for size in 16 32 48 64 128; do
		newicon -s ${size} src/linguist/linguist/images/icons/linguist-${size}-32.png linguist.png
	done
	make_desktop_entry "${QT5_BINDIR}"/linguist 'Qt 5 Linguist' linguist 'Qt;Development;Translation'
}

pkg_postinst() {
	qt5-build_pkg_postinst
	xdg_icon_cache_update
}

pkg_postrm() {
	qt5-build_pkg_postrm
	xdg_icon_cache_update
}
