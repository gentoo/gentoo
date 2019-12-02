# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PVCUT=$(ver_cut 1-2)
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="ModemManager bindings for Qt"
LICENSE="LGPL-2"
KEYWORDS="amd64 ~arm arm64 x86"
IUSE=""

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	net-misc/modemmanager
"
RDEPEND="${DEPEND}"

# requires running environment
RESTRICT+=" test"
