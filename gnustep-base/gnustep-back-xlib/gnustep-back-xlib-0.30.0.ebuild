# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnustep-base

DESCRIPTION="Default X11 back-end component for the GNUstep GUI Library"
HOMEPAGE="https://gnustep.github.io"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-back-${PV}.tar.gz"
S="${WORKDIR}/gnustep-back-${PV}"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="opengl xim"

RDEPEND="${GNUSTEP_CORE_DEPEND}
	=gnustep-base/gnustep-gui-${PV%.*}*
	>=media-libs/freetype-2.1.9
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXft
	x11-libs/libXrender
	opengl? ( virtual/opengl virtual/glu )

	!gnustep-base/gnustep-back-art
	!gnustep-base/gnustep-back-cairo"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	# do not compress man pages
	sed -i '/which gzip/,/&& gzip/d' Tools/GNUmakefile.postamble || die
}

src_configure() {
	egnustep_env

	myconf="$(use_enable opengl glx)"
	myconf="$myconf $(use_enable xim)"
	myconf="$myconf --enable-server=x11"
	myconf="$myconf --enable-graphics=xlib"

	econf $myconf
}
