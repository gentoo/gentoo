# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} != *9999* ]]; then
	QT5_KDEPATCHSET_REV=1
	KEYWORDS="~amd64 ~arm ~hppa ~ppc64 ~sparc ~x86"
fi

QT5_MODULE="qttools"
inherit qt5-build

DESCRIPTION="Tool for reporting diagnostic information about Qt and its environment"

IUSE="+network +widgets"

DEPEND="
	=dev-qt/qtcore-${QT5_PV}*:5=
	=dev-qt/qtgui-${QT5_PV}*:5=
	network? ( =dev-qt/qtnetwork-${QT5_PV}*[ssl] )
	widgets? ( =dev-qt/qtwidgets-${QT5_PV}* )
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/qtdiag
)

src_prepare() {
	qt_use_disable_mod network network \
		src/qtdiag/qtdiag.pro

	qt_use_disable_mod widgets widgets \
		src/qtdiag/qtdiag.pro

	qt5-build_src_prepare
}

src_install() {
	qt5-build_src_install
	qt5_symlink_binary_to_path qtdiag 5
}
