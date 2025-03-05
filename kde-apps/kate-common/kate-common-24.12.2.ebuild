# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="true"
KDE_ORG_NAME="${PN/-common/}"
inherit ecm-common gear.kde.org

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"

RDEPEND="
	!<kde-apps/kate-24.07.90-r1
	!<kde-apps/kate-addons-24.07.90-r1
	!<kde-apps/kate-lib-24.07.90-r1
	!<kde-apps/kwrite-24.07.90-r1
"
