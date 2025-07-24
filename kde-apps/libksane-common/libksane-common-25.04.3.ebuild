# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_NAME="${PN/-common/}"
inherit ecm-common gear.kde.org xdg

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"

RDEPEND="
	!<kde-apps/libksane-24.02.2-r2:5
	!<kde-apps/libksane-24.05.2-r1:6
"

ECM_INSTALL_ICONS=(
	src/16-actions-black-white.png:\${KDE_INSTALL_ICONDIR}
	src/16-actions-color.png:\${KDE_INSTALL_ICONDIR}
	src/16-actions-gray-scale.png:\${KDE_INSTALL_ICONDIR}
)
