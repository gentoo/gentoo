# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.96.0
QTMIN=5.15.5
inherit ecm gear.kde.org

DESCRIPTION="Qt-based interface for SANE library to control scanner hardware"
HOMEPAGE="https://invent.kde.org/libraries/ksanecore
https://api.kde.org/ksanecore/html/index.html"

LICENSE="|| ( LGPL-2.1 LGPL-3 )"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	media-gfx/sane-backends
"
RDEPEND="${DEPEND}"
