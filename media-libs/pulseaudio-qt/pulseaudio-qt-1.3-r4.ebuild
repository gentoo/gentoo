# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_QTHELP="true"
ECM_TEST="optional"
QTMIN=5.15.2
inherit ecm kde.org

DESCRIPTION="Qt bindings for libpulse"
HOMEPAGE="https://invent.kde.org/libraries/pulseaudio-qt"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"
	KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86"
fi

LICENSE="LGPL-2.1"
SLOT="0/3"

RDEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	media-libs/libpulse[glib]
"
DEPEND="${RDEPEND}
	test? (
		>=dev-qt/qtdeclarative-${QTMIN}:5
		>=dev-qt/qtquickcontrols2-${QTMIN}:5
	)
"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${P}-no-crash-if-no-server-response.patch" ) # KDE-bug 454647
