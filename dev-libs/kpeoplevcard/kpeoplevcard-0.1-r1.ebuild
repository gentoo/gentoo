# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_CATEGORY="pim"
KFMIN=5.82.0
QTMIN=5.15.2
inherit ecm kde.org

DESCRIPTION="Library to expose vcards to KPeople"
HOMEPAGE="https://invent.kde.org/pim/kpeoplevcard"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 arm64 ~ppc64 x86"
fi

LICENSE="LGPL-2.1+"
SLOT="5"

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kcontacts-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kpeople-${KFMIN}:5
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-emit-initial-fetch-complete-signal.patch" # KDE-bug 423845
)
