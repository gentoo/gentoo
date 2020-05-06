# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="decoding library for the GIF image file format, written in C"
HOMEPAGE="https://www.netsurf-browser.org/projects/libnsgif/"
SRC_URI="https://download.netsurf-browser.org/libs/releases/${P}-src.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~ppc ppc64 x86 ~m68k-mint"
IUSE=""

BDEPEND="
	>=dev-util/netsurf-buildsystem-1.7-r1
	virtual/pkgconfig
"

src_prepare() {
	default
	sed -e '1i#pragma GCC diagnostic ignored "-Wimplicit-fallthrough"' \
		-i src/lzw.c || die
}

_emake() {
	source /usr/share/netsurf-buildsystem/gentoo-helpers.sh
	netsurf_define_makeconf
	emake "${NETSURF_MAKECONF[@]}" COMPONENT_TYPE=lib-shared $@
}

src_compile() {
	_emake
}

src_install() {
	_emake DESTDIR="${ED}" install
}
