# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_NONGUI=true
KFMIN=5.69.0
inherit ecm kde.org

DESCRIPTION="Plasma Specific Protocols for Wayland"
HOMEPAGE="https://invent.kde.org/libraries/plasma-wayland-protocols"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~ppc64"
fi

LICENSE="LGPL-2.1"
SLOT="0"
