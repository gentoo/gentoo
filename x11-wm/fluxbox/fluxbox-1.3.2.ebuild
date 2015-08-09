# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils flag-o-matic toolchain-funcs prefix

IUSE="nls xinerama bidi +truetype +imlib +slit +toolbar vim-syntax"

DESCRIPTION="Fluxbox is an X11 window manager featuring tabs and an iconbar"

SRC_URI="mirror://sourceforge/fluxbox/${P}.tar.bz2"
HOMEPAGE="http://www.fluxbox.org"

RDEPEND="x11-libs/libXpm
	x11-libs/libXrandr
	x11-libs/libXext
	x11-libs/libXft
	x11-libs/libXrender
	|| ( x11-misc/gxmessage x11-apps/xmessage )
	xinerama? ( x11-libs/libXinerama )
	truetype? ( media-libs/freetype )
	bidi? ( >=dev-libs/fribidi-0.19.2 )
	imlib? ( >=media-libs/imlib2-1.2.0[X] )
	vim-syntax? ( app-vim/fluxbox-syntax )
	!!<x11-themes/fluxbox-styles-fluxmod-20040809-r1
	!!<=x11-misc/fluxconf-0.9.9
	!!<=x11-misc/fbdesk-1.2.1"
DEPEND="bidi? ( virtual/pkgconfig )
	nls? ( sys-devel/gettext )
	x11-proto/xextproto
	${RDEPEND}"

SLOT="0"
LICENSE="MIT"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux"

src_prepare() {
	# We need to be able to include directories rather than just plain
	# files in menu [include] items. This patch will allow us to do clever
	# things with style ebuilds.
	epatch "${FILESDIR}/gentoo_style_location-1.1.x.patch"
	eprefixify util/fluxbox-generate_menu.in

	epatch "${FILESDIR}"/osx-has-otool.patch

	# Add in the Gentoo -r number to fluxbox -version output.
	if [[ "${PR}" == "r0" ]] ; then
		suffix="gentoo"
	else
		suffix="gentoo-${PR}"
	fi
	sed -i \
		-e "s~\(__fluxbox_version .@VERSION@\)~\1-${suffix}~" \
		version.h.in || die "version sed failed"
}

src_configure() {
	use bidi && append-cppflags "$($(tc-getPKG_CONFIG) --cflags fribidi)"

	econf \
		$(use_enable nls) \
		$(use_enable xinerama) \
		$(use_enable truetype xft) \
		$(use_enable imlib imlib2) \
		$(use_enable bidi fribidi ) \
		$(use_enable slit ) \
		$(use_enable toolbar ) \
		--sysconfdir="${EPREFIX}"/etc/X11/${PN} \
		--with-style="${EPREFIX}"/usr/share/fluxbox/styles/Emerge \
		${myconf}
}

src_compile() {
	default

	ebegin "Creating a menu file (may take a while)"
	mkdir -p "${T}/home/.fluxbox" || die "mkdir home failed"
	MENUFILENAME="${S}/data/menu" MENUTITLE="Fluxbox ${PV}" \
		CHECKINIT="no. go away." HOME="${T}/home" \
		"${S}/util/fluxbox-generate_menu" -is -ds \
		|| die "menu generation failed"
	eend $?
}

src_install() {
	dodir /usr/share/fluxbox
	emake DESTDIR="${D}" STRIP="" install
	dodoc README* AUTHORS TODO* ChangeLog NEWS

	dodir /usr/share/xsessions
	insinto /usr/share/xsessions
	doins "${FILESDIR}/${PN}.desktop"

	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}/${PN}.xsession" fluxbox

	dodir /usr/share/fluxbox/menu.d

	# Styles menu framework
	dodir /usr/share/fluxbox/menu.d/styles
	insinto /usr/share/fluxbox/menu.d/styles
	doins "${FILESDIR}/styles-menu-fluxbox"
	doins "${FILESDIR}/styles-menu-commonbox"
	doins "${FILESDIR}/styles-menu-user"
}
