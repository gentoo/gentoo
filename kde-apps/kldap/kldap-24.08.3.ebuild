# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_QTHELP="true"
ECM_TEST="true"
KFMIN=6.5.0
QTMIN=6.7.2
inherit ecm gear.kde.org

DESCRIPTION="Library for interacting with LDAP servers"
HOMEPAGE="https://api.kde.org/kdepim/kldap/html/index.html"

LICENSE="GPL-2+"
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE=""

DEPEND="
	dev-libs/cyrus-sasl
	>=dev-libs/qtkeychain-0.14.2:=[qt6]
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	net-nds/openldap:=
"
RDEPEND="${DEPEND}"
