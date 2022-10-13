# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="true"
ECM_TEST="true"
KFMIN=5.96.0
QTMIN=5.15.5
VIRTUALX_REQUIRED="test"
inherit ecm gear.kde.org

DESCRIPTION="Library to deal with Apple Wallet pass files"
HOMEPAGE="https://apps.kde.org/kontact/"

LICENSE="LGPL-2.1+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
"
RDEPEND="${DEPEND}"
