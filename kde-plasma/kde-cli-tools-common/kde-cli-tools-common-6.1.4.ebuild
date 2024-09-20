# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="true"
KDE_ORG_NAME="${PN/-common/}"
KFMIN=5.115.0
inherit ecm-common plasma.kde.org

LICENSE="GPL-2+ handbook? ( FDL-1.2 )"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"

RDEPEND="!<${CATEGORY}/${KDE_ORG_NAME}-6.1.4-r2:*"
