# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-officeext/texmaths/texmaths-0.37-r1.ebuild,v 1.2 2013/04/27 08:36:13 scarabeus Exp $

EAPI=5

MY_P="TexMaths-${PV}"

OFFICE_EXTENSIONS=(
	"${MY_P}.oxt"
)

inherit office-ext-r1

DESCRIPTION="LaTeX Equation Editor for LibreOffice"
HOMEPAGE="http://roland65.free.fr/texmaths/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.oxt"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="
	app-text/dvisvgm
	virtual/tex-base
"
