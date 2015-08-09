# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit gnustep-base

DESCRIPTION="libart_lgpl back-end component for the GNUstep GUI Library"
HOMEPAGE="http://www.gnustep.org"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-back-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="opengl xim"

RDEPEND="${GNUSTEP_CORE_DEPEND}
	=gnustep-base/gnustep-gui-${PV%.*}*
	opengl? ( virtual/opengl virtual/glu )
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXft
	x11-libs/libXrender
	>=media-libs/freetype-2.1.9

	>=media-libs/libart_lgpl-2.3
	>=gnustep-base/mknfonts-0.5-r1
	media-fonts/dejavu

	!gnustep-base/gnustep-back-cairo
	!gnustep-base/gnustep-back-xlib"
DEPEND="${RDEPEND}"

S=${WORKDIR}/gnustep-back-${PV}

src_configure() {
	egnustep_env

	myconf="$(use_enable opengl glx)"
	myconf="$myconf $(use_enable xim)"
	myconf="$myconf --enable-server=x11"
	myconf="$myconf --enable-graphics=art"

	econf $myconf
}

src_compile() {
	gnustep-base_src_compile

	# Create font lists for DejaVu
	einfo "Generating nfonts support files"
	(
		cd Fonts
		export "${GS_ENV[@]}"
		${GNUSTEP_SYSTEM_TOOLS}/mknfonts \
			$(fc-list : file|grep -v '\.gz'|cut -d: -f1) \
			|| die "nfonts support files creation failed"
		# Trim whitepsaces
		for fdir in *\ */; do
			mv "$fdir" `echo $fdir | tr -d [:space:]`
		done
	)
}

src_install() {
	gnustep-base_src_install

	mkdir -p "${D}/${GNUSTEP_SYSTEM_LIBRARY}/Fonts"
	cp -pPR Fonts/*.nfont "${D}/${GNUSTEP_SYSTEM_LIBRARY}/Fonts"
}

gnustep_config_script() {
	echo "echo ' * setting normal font to DejaVuSans'"
	echo "defaults write NSGlobalDomain NSFont DejaVuSans"
	echo "echo ' * setting bold font to DejaVuSans-Bold'"
	echo "defaults write NSGlobalDomain NSBoldFont DejaVuSans-Bold"
	echo "echo ' * setting fixed font to DejaVuSansMono'"
	echo "defaults write NSGlobalDomain NSUserFixedPitchFont DejaVuSansMono"
}
