# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit xdg cmake

DESCRIPTION="apvlv is a PDF/EPUB Viewer and its behaviour like Vim"
HOMEPAGE="https://github.com/naihe2010/apvlv/"
SRC_URI="https://github.com/naihe2010/apvlv/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug djvu"

DEPEND="
	>=app-text/poppler-0.5.0[cairo,xpdf-headers(+)]
	dev-libs/glib:2
	x11-libs/gtk+:3
	net-libs/webkit-gtk
	app-text/ebook-tools
	djvu? ( app-text/djvu:= )
"
RDEPEND="${DEPEND}"
BDEPEND="
virtual/pkgconfig
"
