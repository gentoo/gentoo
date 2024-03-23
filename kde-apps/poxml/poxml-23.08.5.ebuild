# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
QTMIN=5.15.9
inherit ecm gear.kde.org

DESCRIPTION="KDE utility to translate DocBook XML files using gettext po files"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 arm64 ~riscv x86"
IUSE=""

DEPEND="
	>=dev-qt/qtxml-${QTMIN}:5
	sys-devel/gettext
"
RDEPEND="${DEPEND}"
