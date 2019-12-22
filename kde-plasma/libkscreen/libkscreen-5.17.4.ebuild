# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_QTHELP="true"
ECM_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
KFMIN=5.64.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Plasma screen management library"
LICENSE="GPL-2" # TODO: CHECK
SLOT="5/7"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"
IUSE=""

DEPEND="
	>=kde-frameworks/kwayland-${KFMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	x11-libs/libxcb
"
RDEPEND="${DEPEND}"

# requires running session
RESTRICT+=" test"
