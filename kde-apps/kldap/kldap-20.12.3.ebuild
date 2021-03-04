# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="optional"
ECM_TEST="true"
KFMIN=5.75.0
QTMIN=5.15.2
inherit ecm kde.org

DESCRIPTION="Library for interacting with LDAP servers"
HOMEPAGE="https://api.kde.org/kdepim/kldap/html/index.html"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE=""

DEPEND="
	dev-libs/cyrus-sasl
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kwallet-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	net-nds/openldap
"
RDEPEND="${DEPEND}"
