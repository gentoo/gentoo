# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_QTHELP="true"
ECM_TEST="optional"
KFMIN=5.247.0
QTMIN=6.6.2
inherit ecm kde.org

DESCRIPTION="Qt bindings for libpulse"
HOMEPAGE="https://invent.kde.org/libraries/pulseaudio-qt"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"
	KEYWORDS="~amd64"
fi

LICENSE="LGPL-2.1"
SLOT="0/3"

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,dbus]
	media-libs/libpulse
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qtdeclarative-${QTMIN}:6 )
"
BDEPEND="virtual/pkgconfig"
