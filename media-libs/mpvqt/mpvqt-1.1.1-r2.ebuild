# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.9.0
QTMIN=6.8.1
inherit ecm kde.org

if [[ ${KDE_BUILD_TYPE} == release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"
	KEYWORDS="amd64 arm64 ~ppc64 ~x86"
fi

DESCRIPTION="libmpv wrapper for QtQuick2 and QML"
HOMEPAGE="https://invent.kde.org/libraries/mpvqt"

LICENSE="|| ( GPL-2 GPL-3 LGPL-3 LGPL-2.1 ) CC-BY-SA-4.0 MIT BSD"
SLOT="6/2"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,opengl,wayland,X]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	media-video/mpv:=[libmpv]
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-cmake-minreqver-3.16.patch ) # bug #965104
