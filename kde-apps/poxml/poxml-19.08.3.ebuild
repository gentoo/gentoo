# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="KDE utility to translate DocBook XML files using gettext po files"
LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtxml-${QTMIN}:5
	sys-devel/gettext
"
RDEPEND="${DEPEND}"
