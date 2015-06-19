# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/zathura-meta/zathura-meta-0.ebuild,v 1.8 2014/06/05 09:43:02 ssuominen Exp $

EAPI=5

DESCRIPTION="Meta package for app-text/zathura plugins"
HOMEPAGE="http://pwmt.org/projects/zathura/"
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
