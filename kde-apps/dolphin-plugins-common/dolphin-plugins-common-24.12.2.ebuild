# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_NAME="${PN/-common/}"
inherit ecm-common gear.kde.org

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="
	!<app-cdr/dolphin-plugins-mountiso-24.07.90-r1
	!<kde-apps/dolphin-plugins-dropbox-24.07.90-r1
	!<kde-apps/dolphin-plugins-git-24.07.90-r1
	!<kde-apps/dolphin-plugins-mercurial-24.07.90-r1
	!<kde-apps/dolphin-plugins-subversion-24.07.90-r1
"
