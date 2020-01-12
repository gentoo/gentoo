# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="KControl module for Oyranos CMS cross desktop settings"
HOMEPAGE="https://www.oyranos.org/kolormanager"
SRC_URI="https://github.com/KDE/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="5"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	media-gfx/synnefo
	media-libs/libXcm
	>=media-libs/oyranos-0.9.6
	x11-libs/libXrandr
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}"-deps.patch )
