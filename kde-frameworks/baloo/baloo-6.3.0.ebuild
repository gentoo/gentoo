# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-2)
QTMIN=6.6.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for searching and managing metadata"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE=""

RESTRICT="test" # bug 624250

DEPEND="
	>=dev-db/lmdb-0.9.17
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	=kde-frameworks/kconfig-${PVCUT}*:6
	=kde-frameworks/kcoreaddons-${PVCUT}*:6
	=kde-frameworks/kcrash-${PVCUT}*:6
	=kde-frameworks/kdbusaddons-${PVCUT}*:6
	=kde-frameworks/kfilemetadata-${PVCUT}*:6
	=kde-frameworks/ki18n-${PVCUT}*:6
	=kde-frameworks/kidletime-${PVCUT}*:6
	=kde-frameworks/kio-${PVCUT}*:6
	=kde-frameworks/solid-${PVCUT}*:6
"
RDEPEND="${DEPEND}
	!${CATEGORY}/${PN}:5[-kf6compat(-)]
"
