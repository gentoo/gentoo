# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FONT_SUFFIX="ttf"
inherit font

DESCRIPTION="A monospaced font developed for Windows Terminal"
HOMEPAGE="https://github.com/microsoft/cascadia-code"
SRC_URI="https://github.com/microsoft/cascadia-code/releases/download/v${PV}/CascadiaCode-${PV}.zip -> ${P}.zip"
S="${WORKDIR}/ttf"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

BDEPEND="app-arch/unzip"
