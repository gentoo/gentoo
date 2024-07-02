# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_KDEINSTALLDIRS="false"
ECM_TEST="true"
ECM_EXAMPLES="true"
KFMIN=5.245.0
QTMIN=6.6.2
inherit ecm kde.org

DESCRIPTION="Library for writing accessibility clients such as screen readers"
HOMEPAGE="https://community.kde.org/Accessibility
https://invent.kde.org/libraries/libqaccessibilityclient"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~riscv"
fi

LICENSE="LGPL-2.1"
SLOT="6"
IUSE=""

# tests require DBus
RESTRICT="test"

DEPEND=">=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]"
RDEPEND="${DEPEND}"
