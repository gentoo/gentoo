# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

DESCRIPTION="A typeface made for developers."
HOMEPAGE="https://jetbrains.com/mono"
SRC_URI="https://download.jetbrains.com/fonts/JetBrainsMono-${PV}.zip -> ${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"
FONT_SUFFIX="ttf"
