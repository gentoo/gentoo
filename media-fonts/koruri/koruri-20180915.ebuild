# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Japanese TrueType font based on M+ outline fonts and Open Sans"
HOMEPAGE="https://koruri.github.io/"
SRC_URI="https://github.com/${PN^}/${PN^}/releases/download/${P^}/${P^}.tar.xz"
S="${WORKDIR}/${P^}"

LICENSE="mplus-fonts Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

# Only installs fonts
RESTRICT="binchecks strip"

DOCS=( README{_{E,J}.mplus,_ja.md,.md} )

FONT_SUFFIX="ttf"
