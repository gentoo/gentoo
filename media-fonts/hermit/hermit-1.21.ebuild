# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FONT_SUFFIX="otf"
inherit font

DESCRIPTION="Monospace font designed to be clear, pragmatic and very readable"
HOMEPAGE="https://pcaro.es/p/hermit/"
SRC_URI="https://pcaro.es/d/otf-${P}.tar.gz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv"
IUSE=""

S="${WORKDIR}"
