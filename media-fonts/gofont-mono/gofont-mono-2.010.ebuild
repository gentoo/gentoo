# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

# fonts extracted from go/image repository at commit
# 41969df76e82aeec85fa3821b1e24955ea993001.

DESCRIPTION="Monospace typeface created for the Go programming language"
HOMEPAGE="https://go.dev/blog/go-fonts"
SRC_URI="https://dev.gentoo.org/~matthew/distfiles/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~loong"

FONT_SUFFIX="ttf"
