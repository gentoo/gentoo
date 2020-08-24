# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="A free and open-source typeface for developers"
HOMEPAGE="https://www.jetbrains.com/lp/mono/"
SRC_URI="https://github.com/JetBrains/JetBrainsMono/releases/download/v${PV}/JetBrains.Mono.${PV}.zip -> ${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/JetBrains Mono ${PV}/ttf"
FONT_SUFFIX="ttf"
