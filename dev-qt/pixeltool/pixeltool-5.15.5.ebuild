# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT5_MODULE="qttools"
inherit qt5-build

DESCRIPTION="Qt screen magnifier"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc64 ~sparc ~x86"
fi

IUSE=""

DEPEND="
	=dev-qt/qtcore-${QT5_PV}*:5=
	=dev-qt/qtgui-${QT5_PV}*:5=[png]
	=dev-qt/qtwidgets-${QT5_PV}*
"
RDEPEND="${DEPEND}
	!dev-qt/${PN}:5
	!<dev-qt/qtchooser-66-r2
"

QT5_TARGET_SUBDIRS=(
	src/pixeltool
)

src_install() {
	qt5-build_src_install
	qt5_symlink_binary_to_path pixeltool
}
