# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_NAME="${PN/-trash-desktop-file/}"
inherit desktop frameworks.kde.org

DESCRIPTION="KIO Trash KCM service desktop file"
S="${S}/src/ioslaves/trash"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="amd64 arm64 ~loong ppc64 ~riscv ~x86"

RDEPEND="
	!<kde-frameworks/kio-5.116.0-r2:5
	!kde-apps/kio-extras:6
"

src_configure() { :; }
src_compile() { :; }

src_install() {
	domenu kcm_trash.desktop
}
