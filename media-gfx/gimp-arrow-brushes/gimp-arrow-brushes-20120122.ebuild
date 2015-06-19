# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gimp-arrow-brushes/gimp-arrow-brushes-20120122.ebuild,v 1.5 2013/12/08 10:45:51 pacho Exp $

EAPI="4"

DESCRIPTION="Brushes for GIMP including the styles arrow, handpointer, button arrow and cursor"
HOMEPAGE="http://www.gimphelp.org/index.shtml"
SRC_URI="http://www.gimphelp.org/DL/arrow_brushes_color_1.tar.bz2
	http://www.gimphelp.org/DL/arrow_brushes_color_2.tar.bz2
	http://www.gimphelp.org/DL/arrow_brushes_BW_1.tar.bz2
	http://www.gimphelp.org/DL/arrow_brushes_BW_2.tar.bz2
	http://www.gimphelp.org/DL/arrow_brushes_black_gloss.tar.bz2
	http://www.gimphelp.org/DL/hand_pointer_brushes.tar.bz2
	http://www.gimphelp.org/DL/button_arrow_brushes.tar.bz2
	http://www.gimphelp.org/DL/arrow_action.tar.bz2
	http://www.gimphelp.org/DL/cursor_brushes-1.0.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND=""

S="${WORKDIR}"

src_install() {
	for i in */*.gbr; do
		insinto /usr/share/gimp/2.0/brushes
		doins $i
	done
}
