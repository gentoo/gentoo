# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
KFMIN=5.78.0
QTMIN=5.15.2
inherit ecm kde.org python-single-r1

DESCRIPTION="Plasma frontend for Firewalld or UFW"
HOMEPAGE="https://invent.kde.org/network/plasma-firewall"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/kauth-${KFMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/plasma-${KFMIN}:5
"
RDEPEND="${DEPEND}
	${PYTHON_DEPS}
	|| (
		net-firewall/firewalld
		net-firewall/ufw
	)
"

src_prepare() {
	ecm_src_prepare
	# this kind of cmake magic doesn't work for us at all.
	sed -e "1 s:^.*$:\#\!/usr/bin/env python3.8:" \
		-i kcm/backends/ufw/helper/kcm_ufw_helper.py.cmake || die
}
