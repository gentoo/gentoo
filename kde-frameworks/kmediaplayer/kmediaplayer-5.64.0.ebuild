# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_QTHELP="false"
PVCUT=$(ver_cut 1-2)
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Framework providing a common interface for KParts that can play media files"
LICENSE="MIT"
KEYWORDS="amd64 ~arm arm64 x86"
IUSE=""

DEPEND="
	>=kde-frameworks/kparts-${PVCUT}:5
	>=kde-frameworks/kxmlgui-${PVCUT}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
"
RDEPEND="${DEPEND}"
