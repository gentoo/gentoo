# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Nintendo DS emulator"
HOMEPAGE="http://desmume.org/"
SRC_URI="mirror://sourceforge/desmume/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.8.0:2
	gnome-base/libglade
	x11-libs/gtkglext
	virtual/opengl
	sys-libs/zlib
	dev-libs/zziplib
	media-libs/libsdl[joystick,opengl,video]
	x11-libs/agg"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/intltool"

DOCS=( AUTHORS ChangeLog README README.LIN )

# fix QA compiler warning, see
# https://sourceforge.net/p/desmume/patches/172/
PATCHES=(
	"${FILESDIR}/${P}-fix-pointer-conversion-warning.diff"
	"${FILESDIR}/${P}-gcc6.patch"
)
