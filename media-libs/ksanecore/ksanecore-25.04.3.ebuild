# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.13.0
QTMIN=6.7.2
inherit ecm gear.kde.org

DESCRIPTION="Qt-based interface for SANE library to control scanner hardware"
HOMEPAGE="https://invent.kde.org/libraries/ksanecore
https://api.kde.org/ksanecore/html/index.html"

LICENSE="|| ( LGPL-2.1 LGPL-3 )"
SLOT="6"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv ~x86"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui]
	>=kde-frameworks/ki18n-${KFMIN}:6
	media-gfx/sane-backends
"
RDEPEND="${DEPEND}
	!<media-libs/ksanecore-23.08.5-r2:5
	!media-libs/ksanecore-common
"
