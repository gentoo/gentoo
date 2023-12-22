# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.247.0
QTMIN=6.6.0
inherit ecm plasma.kde.org

DESCRIPTION="Oxygen sound theme for the Plasma desktop"
HOMEPAGE="https://invent.kde.org/plasma/oxygen-sounds"

LICENSE="GPL-2+"
SLOT="6"
KEYWORDS="~amd64"

RDEPEND="!<kde-plasma/oxygen-5.24.80"
