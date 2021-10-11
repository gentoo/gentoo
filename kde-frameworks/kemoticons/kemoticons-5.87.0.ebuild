# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-2)
QTMIN=5.15.2
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Framework for converting text emoticons to graphical representations"
LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""

# requires running kde environment
RESTRICT="test"

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	=kde-frameworks/karchive-${PVCUT}*:5
	=kde-frameworks/kconfig-${PVCUT}*:5
	=kde-frameworks/kcoreaddons-${PVCUT}*:5
	=kde-frameworks/kservice-${PVCUT}*:5
"
RDEPEND="${DEPEND}"
