# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Redesign of Courier"
HOMEPAGE="https://www.quoteunquoteapps.com/courierprime/"
SRC_URI="https://dev.gentoo.org/~jstein/dist/${P}.tar.xz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~loong ~riscv x86"

DOCS=( README-CourierPrime.txt README-CourierPrimeSans.txt README-CourierPrimeSource.txt )

FONT_SUFFIX="ttf"
