# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Brushes for GIMP with the styles arrow, handpointer, button arrow and cursor"
HOMEPAGE="http://www.gimphelp.org/index.html"
# http://www.gimphelp.org/DL/ refuses wget without user-agent
SRC_URI="
	https://dev.gentoo.org/~pacho/${PN}/arrow_brushes_color_1.tar.bz2
	https://dev.gentoo.org/~pacho/${PN}/arrow_brushes_color_2.tar.bz2
	https://dev.gentoo.org/~pacho/${PN}/arrow_brushes_BW_1.tar.bz2
	https://dev.gentoo.org/~pacho/${PN}/arrow_brushes_BW_2.tar.bz2
	https://dev.gentoo.org/~pacho/${PN}/arrow_brushes_black_gloss.tar.bz2
	https://dev.gentoo.org/~pacho/${PN}/hand_pointer_brushes.tar.bz2
	https://dev.gentoo.org/~pacho/${PN}/button_arrow_brushes.tar.bz2
	https://dev.gentoo.org/~pacho/${PN}/arrow_action.tar.bz2
	https://dev.gentoo.org/~pacho/${PN}/cursor_brushes-1.0.tar.bz2
	https://dev.gentoo.org/~pacho/${PN}/circle_brushes-1.0.tar.bz2
	https://dev.gentoo.org/~pacho/${PN}/checkmark_brushes-1.0.tar.bz2
	https://dev.gentoo.org/~pacho/${PN}/star_brushes.tar.bz2
"

LICENSE="GPL-3+"
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
