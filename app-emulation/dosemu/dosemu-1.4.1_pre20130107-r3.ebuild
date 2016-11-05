# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils flag-o-matic pax-utils toolchain-funcs

P_FD="dosemu-freedos-1.0-bin"
COMMIT="15cfb41ff20a052769d753c3262c57ecb050ad71"

DESCRIPTION="DOS Emulator"
HOMEPAGE="http://www.dosemu.org/"
SRC_URI="mirror://sourceforge/dosemu/${P_FD}.tgz
	https://sourceforge.net/code-snapshots/git/d/do/dosemu/code.git/dosemu-code-${COMMIT}.zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="X svga gpm debug alsa sndfile fluidsynth"

RDEPEND="X? ( x11-libs/libX11
		x11-libs/libXxf86vm
		x11-libs/libXau
		x11-libs/libXext
		x11-libs/libXdmcp
		x11-apps/xset
		x11-apps/xlsfonts
		x11-apps/bdftopcf
		x11-apps/mkfontdir )
	svga? ( media-libs/svgalib )
	gpm? ( sys-libs/gpm )
	alsa? ( media-libs/alsa-lib )
	sndfile? ( media-libs/libsndfile )
	fluidsynth? ( media-sound/fluidsynth
		media-sound/fluid-soundfont )
	media-libs/libsdl
	>=sys-libs/slang-1.4"

DEPEND="${RDEPEND}
	X? ( x11-proto/xf86dgaproto )
	>=sys-devel/autoconf-2.57"

S="${WORKDIR}/${PN}-code-${COMMIT}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-fortify.patch
	epatch "${FILESDIR}"/${PN}-1.4.1_pre20091009-dash.patch
	epatch "${FILESDIR}"/${P}-no-glibc.patch

	epatch_user

	# Has problems with -O3 on some systems
	replace-flags -O[3-9] -O2

	# This one is from media-sound/fluid-soundfont (bug #479534)
	sed "s,/usr/share/soundfonts/default.sf2,${EPREFIX}/usr/share/sounds/sf2/FluidR3_GM.sf2,"\
		-i src/plugin/fluidsynth/mid_o_flus.c || die

	eautoreconf
}

src_configure() {
	econf $(use_with X x) \
		$(use_with svga svgalib) \
		$(use_enable debug) \
		$(use_with gpm) \
		$(use_with alsa) \
		$(use_with sndfile) \
		$(use_with fluidsynth) \
		--with-fdtarball="${DISTDIR}"/${P_FD}.tgz \
		--sysconfdir="${EPREFIX}"/etc/dosemu/ \
		--with-docdir="${EPREFIX}"/usr/share/doc/${PF}
}

src_compile() {
	emake AR=$(tc-getAR)
}

src_install() {
	default

	# r - randmmap: dosemu tries to get address mapping
	#     exactly where asked, loops otherwise.
	# m - allow RWX mapping: as it's an emulator / code loader
	pax-mark -mr "${ED}/usr/bin/dosemu.bin"
}
