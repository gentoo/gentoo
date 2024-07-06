# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.3.0
QTMIN=6.6.2
inherit ecm gear.kde.org

DESCRIPTION="Qt-based interface for SANE library to control scanner hardware"
HOMEPAGE="https://invent.kde.org/libraries/ksanecore
https://api.kde.org/ksanecore/html/index.html"

LICENSE="|| ( LGPL-2.1 LGPL-3 )"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~riscv"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui]
	>=kde-frameworks/ki18n-${KFMIN}:6
	media-gfx/sane-backends
"
RDEPEND="${DEPEND}
	!${CATEGORY}/${PN}:5[-kf6compat(-)]
"
