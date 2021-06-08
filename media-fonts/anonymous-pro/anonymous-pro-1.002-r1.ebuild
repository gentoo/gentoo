# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="AnonymousPro-${PV}"
inherit font

DESCRIPTION="Monospaced truetype font designed with coding in mind"
HOMEPAGE="https://www.marksimonson.com/fonts/view/anonymous-pro"
SRC_URI="https://www.marksimonson.com/assets/content/fonts/${MY_P}.zip"
S="${WORKDIR}/${MY_P}.001"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 x86 ~x64-macos"
IUSE=""

RESTRICT="binchecks strip"

BDEPEND="app-arch/unzip"

FONT_SUFFIX="ttf"
