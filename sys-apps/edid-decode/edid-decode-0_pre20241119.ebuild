# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson toolchain-funcs

EGIT_COMMIT="5332a3b76080e17137db15fd31e2d3949cef5f84"
MY_P="${PN}-${EGIT_COMMIT}"

DESCRIPTION="Decode EDID data in a human-readable format"
HOMEPAGE="https://git.linuxtv.org/edid-decode.git/"
SRC_URI="https://dev.gentoo.org/~conikost/distfiles/${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="examples"

src_compile() {
	tc-export CXX
	meson_src_compile
}

src_install() {
	meson_src_install
	einstalldocs

	if use examples; then
		insinto /usr/share/edid-decode/examples
		doins data/*
	fi
}
