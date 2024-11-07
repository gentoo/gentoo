# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_I18N="false"
KDE_ORG_NAME="${PN/-common/}"
KFMIN=5.115.0
inherit ecm-common gear.kde.org

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"

RDEPEND="
	!<kde-apps/ffmpegthumbs-23.08.5-r1:5
	!<kde-apps/ffmpegthumbs-24.05.2-r1:6
"

ECM_INSTALL_FILES=(
	ffmpegthumbnailersettings5.kcfg:\${KDE_INSTALL_KCFGDIR}
	org.kde.ffmpegthumbs.metainfo.xml:\${KDE_INSTALL_METAINFODIR}
)
