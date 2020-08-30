# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="linux implementation of the mirc dccserver command"
HOMEPAGE="https://www.nih.at/dccserver/"
SRC_URI="https://www.nih.at/dccserver/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"

src_prepare() {
	default

	# Respect AR
	sed -i -e "s/AR = /AR ?= /" lib/Makefile.in || die
}

src_compile() {
	AR="$(tc-getAR)" default
}
