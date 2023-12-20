# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_DESIGNERPLUGIN="true"
PVCUT=$(ver_cut 1-2)
QTMIN=6.6.0
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for common completion tasks such as filename or URL completion"

LICENSE="LGPL-2+"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui]
	=kde-frameworks/kcodecs-${PVCUT}*:6
	=kde-frameworks/kconfig-${PVCUT}*:6
	=kde-frameworks/kcoreaddons-${PVCUT}*:6
	=kde-frameworks/kwidgetsaddons-${PVCUT}*:6
"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6[linguist]"
