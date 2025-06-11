# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dot-a toolchain-funcs

DESCRIPTION="Fast Base64 encoding/decoding routines"
HOMEPAGE="https://github.com/libb64/libb64/"
SRC_URI="
	https://github.com/libb64/libb64/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CC-PD"
# static library, so always rebuild
SLOT="0/${PVR}"
KEYWORDS="amd64 ~arm64 x86"

BDEPEND="app-arch/unzip"

src_configure() {
	lto-guarantee-fat
	tc-export CC AR
}

src_compile() {
	# override -O3, -Werror non-sense
	emake -C src CFLAGS="${CFLAGS} -I../include"
}

src_install() {
	dolib.a src/libb64.a
	insinto /usr/include
	doins -r include/b64
	einstalldocs
	strip-lto-bytecode
}
