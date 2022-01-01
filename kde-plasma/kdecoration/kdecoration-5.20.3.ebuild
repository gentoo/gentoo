# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="forceoptional"
KFMIN=5.74.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.15.1
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Plugin based library to create window decorations"

LICENSE="|| ( LGPL-2.1 LGPL-3 )"
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
"
RDEPEND="${DEPEND}"
