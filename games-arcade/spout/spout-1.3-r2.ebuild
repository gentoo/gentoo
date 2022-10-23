# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop readme.gentoo-r1

MY_P="spout-unix-${PV}"

DESCRIPTION="Abstract Japanese caveflier / shooter"
HOMEPAGE="http://freshmeat.net/projects/spout/"
SRC_URI="http://rohanpm.net/files/old/${MY_P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=media-libs/libsdl-1.2.6"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${PN}-1.3-Fix-implicit-function-declarations.patch
)

src_install() {
	dobin spout
	einstalldocs

	doicon spout.png
	make_desktop_entry spout "Spout"

	local DOC_CONTENTS="
	To play in fullscreen mode, do 'spout f'.
	To play in a greater resolution, do 'spout x', where
	x is an integer; the larger x is, the higher the resolution.

	To play:
	* Accelerate - spacebar, enter, z, x
	* Pause - escape
	* Exit - shift+escape
	* Rotate - left or right"
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
