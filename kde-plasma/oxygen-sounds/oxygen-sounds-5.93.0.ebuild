# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.249.0
QTMIN=6.6.2
inherit ecm plasma.kde.org

DESCRIPTION="Oxygen sound theme for the Plasma desktop"
HOMEPAGE="https://invent.kde.org/plasma/oxygen-sounds"

LICENSE="GPL-2+"
SLOT="6"
KEYWORDS="~amd64"

RDEPEND="!<kde-plasma/oxygen-5.24.80"
