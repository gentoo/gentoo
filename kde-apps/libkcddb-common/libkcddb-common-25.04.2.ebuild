# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="true"
ECM_HANDBOOK_DIR=( kcmcddb/doc )
ECM_KCM_TARGETS=( kcm_cddb:kcmcddb/ )
KDE_ORG_NAME="${PN/-common/}"
inherit ecm-common gear.kde.org

LICENSE="GPL-2+ handbook? ( FDL-1.2 )"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="
	!<kde-apps/libkcddb-23.08.5-r1:5
	!<kde-apps/libkcddb-24.05.2-r1:6
"

ECM_INSTALL_FILES=(
	libkcddb/libkcddb5.kcfg:\${KDE_INSTALL_KCFGDIR}
)
