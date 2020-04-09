# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
QT5_MODULE="qttools"
inherit desktop qt5-build xdg-utils

DESCRIPTION="Tool for viewing on-line documentation in Qt help file format"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc64 ~sparc ~x86"
fi

IUSE="webkit"

DEPEND="
	~dev-qt/qtcore-${PV}:5=
	~dev-qt/qtgui-${PV}
	~dev-qt/qthelp-${PV}
	~dev-qt/qtnetwork-${PV}
	~dev-qt/qtprintsupport-${PV}
	~dev-qt/qtsql-${PV}[sqlite]
	~dev-qt/qtwidgets-${PV}
	webkit? ( >=dev-qt/qtwebkit-5.9.1:5 )
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/assistant/assistant
)

src_prepare() {
	qt_use_disable_mod webkit webkitwidgets \
		src/assistant/assistant/assistant.pro

	qt5-build_src_prepare
}

src_install() {
	qt5-build_src_install

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
