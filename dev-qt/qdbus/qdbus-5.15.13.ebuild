# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} != *9999* ]]; then
	QT5_KDEPATCHSET_REV=1
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

QT5_MODULE="qttools"
inherit qt5-build

DESCRIPTION="Interface to Qt applications communicating over D-Bus"

IUSE=""

DEPEND="
	=dev-qt/qtcore-${QT5_PV}*
	=dev-qt/qtdbus-${QT5_PV}*
	=dev-qt/qtxml-${QT5_PV}*
"
RDEPEND="${DEPEND}
	!dev-qt/${PN}:5
	!<dev-qt/qtchooser-66-r2
"

QT5_TARGET_SUBDIRS=(
	src/qdbus/qdbus
)

src_install() {
	qt5-build_src_install
	qt5_symlink_binary_to_path qdbus
}
