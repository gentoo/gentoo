# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature unpacker

DESCRIPTION="Set of utilities for manipulating terminal fonts and colors"
HOMEPAGE="https://inai.de/projects/consoleet/"
SRC_URI="https://inai.de/files/consoleet/${P}.tar.zst"

LICENSE="GPL-3+ MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	!<dev-util/hxtools-20251011
	>=media-libs/babl-0.1
	dev-cpp/eigen:3=
	dev-lang/perl
	>=sys-libs/libhx-4.28:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	$(unpacker_src_uri_depends)
	virtual/pkgconfig
"

pkg_postinst() {
	optfeature_header "extra tools for extended font format support"
	optfeature "X11 Portable Compiled Format (pcf)" x11-apps/bdftopcf
	optfeature "PS Type 1/TrueType/OpenType/WOFF (pfa, ttf, otf, woff)" media-gfx/fontforge
}
