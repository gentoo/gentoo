# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-qt/qtgraphicaleffects/qtgraphicaleffects-5.4.2.ebuild,v 1.1 2015/06/17 15:20:46 pesa Exp $

EAPI=5
inherit qt5-build virtualx

DESCRIPTION="Set of QML types for adding visual effects to user interfaces"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~hppa ~ppc64 ~x86"
fi

IUSE=""

RDEPEND="
	>=dev-qt/qtcore-${PV}:5
	>=dev-qt/qtdeclarative-${PV}:5
	>=dev-qt/qtxmlpatterns-${PV}:5
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qtgui-${PV}:5 )
"

src_test() {
	local VIRTUALX_COMMAND="qt5-build_src_test"
	virtualmake
}
