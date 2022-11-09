# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="TeX's Computer Modern Fonts for MathML"
HOMEPAGE="http://www.mozilla.org/projects/mathml/fonts/"
SRC_URI="https://dev.gentoo.org/~mgorny/dist/${P}.zip"

LICENSE="bakoma"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}"

FONT_S="${S}"
FONT_SUFFIX="ttf"
