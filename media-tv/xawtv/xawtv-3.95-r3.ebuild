# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils font autotools flag-o-matic

PATCHLEVEL="4"

IUSE="aalib alsa dv lirc cpu_flags_x86_mmx motif nls opengl quicktime X xv zvbi xext"

MY_FONT=tv-fonts-1.1
DESCRIPTION="Small suite of video4linux related software"
HOMEPAGE="http://bytesex.org/xawtv/"
SRC_URI="http://dl.bytesex.org/releases/xawtv/${P}.tar.gz
	X? ( http://dl.bytesex.org/releases/tv-fonts/${MY_FONT}.tar.bz2 )
	mirror://gentoo/${PN}-patches-${PATCHLEVEL}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"

RDEPEND=">=sys-libs/ncurses-5.1
	virtual/jpeg:0
	X? (
		x11-libs/libFS
		x11-libs/libXmu
		x11-libs/libX11
		x11-libs/libXaw
		x11-libs/libXt
		x11-libs/libXext
		x11-libs/libXrender
		xext? (
			x11-libs/libXinerama
			x11-libs/libXxf86dga
			x11-libs/libXrandr
			x11-libs/libXxf86vm
		)
		x11-apps/xset
		xv? ( x11-libs/libXv )
	)
	motif? ( >=x11-libs/motif-2.3:0
		app-text/recode )
	alsa? ( media-libs/alsa-lib )
	aalib? ( media-libs/aalib )
	dv? ( media-libs/libdv )
	lirc? ( app-misc/lirc )
	opengl? ( virtual/opengl )
	quicktime? ( media-libs/libquicktime )
	zvbi? ( media-libs/zvbi
		media-libs/libpng:0 )"

DEPEND="${RDEPEND}
	X? (
		x11-apps/xset
		x11-apps/bdftopcf
		x11-proto/videoproto
		xext? ( x11-proto/xineramaproto )
	)"

pkg_setup() {
	if use X; then
		font_pkg_setup
	fi
}

src_prepare() {
	if use X; then
		cd "${WORKDIR}/${MY_FONT}"
		epatch "${WORKDIR}/patches/extra/${MY_FONT}-nox.patch"
	fi
	cd "${S}"

	EPATCH_SUFFIX="patch" epatch "${WORKDIR}/patches"
	epatch "${FILESDIR}/${P}-libquicktime-compat.patch"
	epatch "${FILESDIR}/${P}-pagemask-fix.patch"
	epatch "${FILESDIR}/${P}-jpeg-7.patch"
	eautoreconf
}

src_configure() {
	# It tries to include FSlib.h directly, but this seems to have moved.
	use X && has_version x11-libs/libFS && append-flags -I/usr/include/X11/fonts

	econf \
		$(use_with X x) \
		$(use_enable xext xfree-ext) \
		$(use_enable xv xvideo) \
		$(use_enable dv)  \
		$(use_enable cpu_flags_x86_mmx mmx) \
		$(use_enable motif) \
		$(use_enable quicktime) \
		$(use_enable alsa) \
		$(use_enable lirc) \
		$(use_enable opengl gl) \
		$(use_enable zvbi) \
		$(use_enable aalib aa)
}

src_compile() {
	emake verbose=yes

	if use X; then
		cd "${WORKDIR}/${MY_FONT}"
		emake -j1 DISPLAY=
	fi
}

src_install() {
	make install DESTDIR="${D}" resdir="${D}"/usr/share/X11 || die

	# v4lctl is only installed automatically if the X USE flag is enabled
	use X || \
		dobin x11/v4lctl

	dodoc Changes README* TODO "${FILESDIR}"/webcamrc
	docinto cgi-bin
	dodoc scripts/webcam.cgi

	use X || \
		rm -f "${D}"/usr/share/man/man1/{pia,propwatch}.1 \
			"${D}"/usr/share/{man,man/fr,man/es}/man1/xawtv.1 \
			"${D}"/usr/share/{man,man/es}/man1/rootv.1

	use motif || \
		rm -f "${D}"/usr/share/man/man1/{motv,mtt}.1

	use zvbi || \
		rm -f "${D}"/usr/share/man/man1/{alevtd,mtt}.1 \
			"${D}"/usr/share/{man,man/es}/man1/scantv.1

	use nls || \
		rm -f "${D}"/usr/share/man/fr \
			"${D}"/usr/share/man/es

	# The makefile seems to be fubar'd for some data
	dodir /usr/share/${PN}
	mv "${D}"/usr/share/*.list "${D}"/usr/share/${PN}
	mv "${D}"/usr/share/Index* "${D}"/usr/share/${PN}

	if use X; then
		cd "${WORKDIR}/${MY_FONT}"
		insinto /usr/share/fonts/xawtv
		doins *.gz fonts.alias

		font_xfont_config
	fi
}

pkg_postinst() {
	if use X; then
		ebegin "installing teletype fonts into /usr/share/fonts/xawtv"
		cd /usr/share/fonts/xawtv
		mkfontdir
		eend
	fi
}
