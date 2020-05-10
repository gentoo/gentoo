# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

EGIT_COMMIT="74b64180d67bb009d8d9ea1b6f18ad41aaa16396"
MY_P="${PN}-${EGIT_COMMIT}"

DESCRIPTION="Decode EDID data in a human-readable format"
HOMEPAGE="https://git.linuxtv.org/edid-decode.git/"
SRC_URI="https://dev.gentoo.org/~conikost/files/${MY_P}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="MIT"
SLOT="0"
IUSE="examples"

S="${WORKDIR}/${MY_P}"

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
