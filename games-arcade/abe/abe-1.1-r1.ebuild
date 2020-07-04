# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop toolchain-funcs

DESCRIPTION="A scrolling, platform-jumping, key-collecting, ancient pyramid exploring game"
HOMEPAGE="http://abe.sourceforge.net/"
SRC_URI="mirror://sourceforge/abe/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsdl[sound,video]
	x11-libs/libXi
	media-libs/sdl-mixer[vorbis]"
RDEPEND=${DEPEND}

src_unpack() {
	unpack ${A}
	cd "${S}"
	unpack ./images/images.tar
}

PATCHES=(
	# From Fedora:
	# Enable changing the video settings.  Sent upstream 2 Apr 2006:
	# https://sourceforge.net/p/abe/bugs/1/
	"${FILESDIR}"/${P}-settings.patch

	# Fix a double free() bug.  Sent upstream 15 Mar 2011:
	# https://sourceforge.net/p/abe/patches/1/
	"${FILESDIR}"/${P}-doublefree.patch

	# Fix an incorrect printf format specifier.  Sent upstream 15 Mar 2011:
	# https://sourceforge.net/p/abe/patches/2/
	"${FILESDIR}"/${P}-format.patch

	# Fix build failure with -Werror=format-security
	"${FILESDIR}"/${P}-format-security.patch
)

src_prepare() {
	default
	sed -i \
		-e "/^TR_CFLAGS/d" \
		-e "/^TR_CXXFLAGS/d" \
		configure || die
}

src_configure() {
	econf --with-data-dir=/usr/share/${PN}
}

src_install() {
	dobin src/abe
	insinto /usr/share/${PN}
	doins -r images sounds maps
	newicon tom1.bmp abe.bmp
	make_desktop_entry abe "Abe's Amazing Adventure" /usr/share/pixmaps/abe.bmp
	einstalldocs
}
