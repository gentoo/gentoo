# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Meta package for app-text/zathura plugins"
HOMEPAGE="https://pwmt.org/projects/zathura/"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="cb djvu +pdf postscript"

RDEPEND="app-text/zathura
	cb? ( app-text/zathura-cb )
	djvu? ( app-text/zathura-djvu )
	pdf? ( || ( app-text/zathura-pdf-poppler app-text/zathura-pdf-mupdf ) )
	postscript? ( app-text/zathura-ps )"
