# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Meta package for app-text/zathura plugins"
HOMEPAGE="https://pwmt.org/projects/zathura/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="cb djvu epub +pdf postscript"

RDEPEND="
	app-text/zathura
	cb? ( app-text/zathura-cb )
	djvu? ( app-text/zathura-djvu )
	epub? ( app-text/zathura-pdf-mupdf )
	pdf? ( || (
			app-text/zathura-pdf-poppler
			app-text/zathura-pdf-mupdf
	) )
	postscript? ( app-text/zathura-ps )
"
