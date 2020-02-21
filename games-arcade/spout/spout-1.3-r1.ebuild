# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop readme.gentoo-r1

MY_P="spout-unix-${PV}"
DESCRIPTION="Abstract Japanese caveflier / shooter"
HOMEPAGE="http://freshmeat.net/projects/spout/"
SRC_URI="http://rohanpm.net/files/old/${MY_P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-libs/libsdl-1.2.6"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
To play in fullscreen mode, do 'spout f'.
To play in a greater resolution, do 'spout x', where
x is an integer; the larger x is, the higher the resolution.

To play:
* Accelerate - spacebar, enter, z, x
* Pause - escape
* Exit - shift+escape
* Rotate - left or right
"

src_install() {
	dobin spout
	doicon spout.png
	make_desktop_entry spout "Spout"
	einstalldocs
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
