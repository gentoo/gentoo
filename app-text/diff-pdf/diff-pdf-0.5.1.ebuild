# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"
inherit wxwidgets

DESCRIPTION="A simple tool for visually comparing two PDF files"
HOMEPAGE="https://vslavik.github.io/diff-pdf/ https://github.com/vslavik/diff-pdf/"
SRC_URI="https://github.com/vslavik/${PN}/releases/download/v${PV}/${P}.tar.gz"

# The COPYING.icons file states that two icons were taken from
# version 2.16.5 of GTK+, which is licensed LGPL-2+.
LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

# The build system checks for "poppler-glib", which is provided only
# when app-text/poppler is built with USE=cairo. Moreover the glib ABI
# of poppler is relatively stable, and I can only assume that diff-pdf
# uses that rather than the low-level libpoppler.so API. Since the
# subslot on app-text/poppler is ONLY for the low-level API, we
# therefore don't need a subslot dependency on app-text/poppler.
#
# Since diff-pdf.cpp includes glib.h directly, I've included
# dev-libs/glib as an explicit dependency. Ditto for x11-libs/cairo.
DEPEND="app-text/poppler[cairo]
	dev-libs/glib
	x11-libs/cairo
	x11-libs/wxGTK:${WX_GTK_VER}[X]"
RDEPEND="${DEPEND}"

src_configure() {
	setup-wxwidgets
	default
}
