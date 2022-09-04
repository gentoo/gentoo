# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-2)
QTMIN=5.15.4
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for getting the usage statistics collected by the activities service"
LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE=""

RDEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5
	=kde-frameworks/kactivities-${PVCUT}*:5
	=kde-frameworks/kconfig-${PVCUT}*:5
"
DEPEND="${RDEPEND}
	test? ( dev-libs/boost )
"
