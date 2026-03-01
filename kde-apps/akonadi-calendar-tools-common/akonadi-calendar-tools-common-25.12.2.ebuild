# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="true"
KDE_ORG_NAME="${PN/-common/}"
inherit ecm-common gear.kde.org

LICENSE="GPL-2 handbook? ( FDL-1.2+ )"
SLOT="0"
KEYWORDS="amd64 arm64"

RDEPEND="
	!<kde-apps/calendarjanitor-24.07.90-r1
	!<kde-apps/konsolekalendar-24.07.90-r1
"
