# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=1f9d2915c03949d565464c419b045e2770f553d1
inherit cmake xdg

DESCRIPTION="Monitor program for use with Icecream compile clusters"
HOMEPAGE="https://en.opensuse.org/Icecream https://github.com/icecc/icemon"
SRC_URI="https://github.com/icecc/icemon/archive/${COMMIT}.tar.gz -> ${P}-${COMMIT:0:8}.tar.gz"
S="${WORKDIR}"/${PN}-${COMMIT}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-qt/qtbase:6[gui,widgets]
	>=sys-devel/icecream-1.3
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/asciidoc
	kde-frameworks/extra-cmake-modules
"
