# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit netsurf

DESCRIPTION="Decoding library for the GIF image file format, written in C"
HOMEPAGE="https://www.netsurf-browser.org/projects/libnsgif/"
SRC_URI="https://download.netsurf-browser.org/libs/releases/${P}-src.tar.gz"

LICENSE="MIT"
# The soname is $PV, which usually means it can't be trusted, which
# ironically means that it's the correct subslot.
SLOT="0/${PV}"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~x86"

BDEPEND="
	dev-build/netsurf-buildsystem
	virtual/pkgconfig
"

src_prepare() {
	default
	sed -e '1i#pragma GCC diagnostic ignored "-Wimplicit-fallthrough"' \
		-i src/lzw.c || die
}

_emake() {
	netsurf_define_makeconf
	emake "${NETSURF_MAKECONF[@]}" COMPONENT_TYPE=lib-shared $@
}

src_compile() {
	_emake
}

src_install() {
	_emake DESTDIR="${D}" install
}
