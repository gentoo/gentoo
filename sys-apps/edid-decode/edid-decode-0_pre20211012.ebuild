# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

EGIT_COMMIT="985024f0ccb7eb0014397f2d562ecebfdd340c3b"
MY_P="${PN}-${EGIT_COMMIT}"

DESCRIPTION="Decode EDID data in a human-readable format"
HOMEPAGE="https://git.linuxtv.org/edid-decode.git/"
SRC_URI="https://dev.gentoo.org/~conikost/files/${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

KEYWORDS="amd64 x86"
LICENSE="MIT"
SLOT="0"
IUSE="examples"

src_compile() {
	tc-export CXX
	default
}

src_install() {
	emake DESTDIR="${ED}" install
	einstalldocs

	if use examples; then
		insinto /usr/share/edid-decode/examples
		doins data/*
	fi
}
