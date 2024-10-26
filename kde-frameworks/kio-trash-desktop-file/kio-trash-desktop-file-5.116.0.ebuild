# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_I18N="false"
ECM_HANDBOOK="false"
KDE_ORG_NAME="${PN/-trash-desktop-file/}"
KFMIN=5.115.0
inherit ecm-common frameworks.kde.org

DESCRIPTION="KIO Trash KCM service desktop file"
S="${S}/src/ioslaves/trash"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="amd64 ~arm arm64 ~loong ppc64 ~riscv x86"

RDEPEND="
	!<kde-frameworks/kio-5.116.0-r2:5
	!kde-apps/kio-extras:6
"

ECM_INSTALL_FILES=(
	kcm_trash.desktop:\${KDE_INSTALL_APPDIR}
)
