# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs

DESCRIPTION="Tool for adjusting EXIF tags of your photos with a recorded GPS trace"
HOMEPAGE="https://github.com/freefoote/gpscorrelate"
SRC_URI="http://freefoote.dview.net/linux/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE="doc gtk"

RDEPEND="
	dev-libs/libxml2:2
	media-gfx/exiv2:=
	gtk? ( x11-libs/gtk+:2 )
"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.2
	dev-libs/libxslt
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}/${PN}-1.6.1-makefile.patch" )

src_compile() {
	tc-export CC CXX
	local opts="gpscorrelate gpscorrelate.1"
	use gtk && opts+=" gpscorrelate-gui BUILD_GUI=1"
	emake ${opts}
}

src_install() {
	dobin ${PN}
	if use gtk; then
		dobin ${PN}-gui
		doicon ${PN}-gui.svg
		domenu ${PN}.desktop
	fi
	if use doc; then
		dohtml doc/*
	fi
	doman ${PN}.1
}
