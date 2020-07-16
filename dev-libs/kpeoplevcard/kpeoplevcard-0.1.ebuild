# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KFMIN=5.64.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Library to expose vcards to KPeople"
HOMEPAGE="https://invent.kde.org/pim/kpeoplevcard"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~arm64 x86"
fi

LICENSE="LGPL-2.1+"
SLOT="5"

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kcontacts-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kpeople-${KFMIN}:5
"
RDEPEND="${DEPEND}"
