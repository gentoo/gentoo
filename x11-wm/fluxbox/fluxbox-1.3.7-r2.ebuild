# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/fluxbox/fluxbox-1.3.7-r2.ebuild,v 1.1 2015/06/09 03:42:47 zlg Exp $

EAPI=5
inherit eutils flag-o-matic toolchain-funcs prefix

IUSE="nls xinerama bidi +truetype +imlib +slit +systray +toolbar vim-syntax"

REQUIRED_USE="systray? ( toolbar )"

DESCRIPTION="Fluxbox is an X11 window manager featuring tabs and an iconbar"

SRC_URI="mirror://sourceforge/fluxbox/${P}.tar.xz"
HOMEPAGE="http://www.fluxbox.org"
SLOT="0"
LICENSE="MIT"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux"

RDEPEND="
	!!<=x11-misc/fbdesk-1.2.1
	!!<=x11-misc/fluxconf-0.9.9
	!!<x11-themes/fluxbox-styles-fluxmod-20040809-r1
	bidi? ( >=dev-libs/fribidi-0.19.2 )
	imlib? ( >=media-libs/imlib2-1.2.0[X] )
	truetype? ( media-libs/freetype )
	vim-syntax? ( app-vim/fluxbox-syntax )
	x11-libs/libXext
	x11-libs/libXft
	x11-libs/libXpm
	x11-libs/libXrandr
	x11-libs/libXrender
	xinerama? ( x11-libs/libXinerama )
	|| ( x11-misc/gxmessage x11-apps/xmessage )
"
DEPEND="
	${RDEPEND}
	bidi? ( virtual/pkgconfig )
	nls? ( sys-devel/gettext )
	x11-proto/xextproto
"

src_prepare() {
	# We need to be able to include directories rather than just plain
	# files in menu [include] items. This patch will allow us to do clever
	# things with style ebuilds.
	epatch "${FILESDIR}"/gentoo_style_location-1.1.x.patch

	eprefixify util/fluxbox-generate_menu.in

	epatch "${FILESDIR}"/osx-has-otool.patch

	# Fix bug #551522; 1.3.8 will render this obsolete
	epatch "${FILESDIR}"/fix-hidden-toolbar.patch

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

	econf $(use_enable bidi fribidi ) \
		$(use_enable imlib imlib2) \
		$(use_enable nls) \
		$(use_enable slit ) \
		$(use_enable systray ) \
		$(use_enable toolbar ) \
		$(use_enable truetype xft) \
		$(use_enable xinerama) \
		--sysconfdir="${EPREFIX}"/etc/X11/${PN} \
		--with-style="${EPREFIX}"/usr/share/fluxbox/styles/Emerge
}

src_compile() {
	default

	ebegin "Creating a menu file (may take a while)"
	mkdir -p "${T}/home/.fluxbox" || die "mkdir home failed"
	# Call fluxbox-generate_menu through bash since it lacks +x
	# chmod 744 may be an equal fix
	MENUFILENAME="${S}/data/menu" MENUTITLE="Fluxbox ${PV}" \
		CHECKINIT="no. go away." HOME="${T}/home" \
		bash "${S}/util/fluxbox-generate_menu" -is -ds \
		|| die "menu generation failed"
	eend $?
}

src_install() {
	emake DESTDIR="${D}" STRIP="" install
	dodoc README* AUTHORS TODO* ChangeLog NEWS

	# Install the generated menu
	insinto /usr/share/fluxbox
	doins data/menu

	insinto /usr/share/xsessions
	doins "${FILESDIR}"/${PN}.desktop

	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}"/${PN}.xsession fluxbox

	# Styles menu framework
	insinto /usr/share/fluxbox/menu.d/styles
	doins "${FILESDIR}"/styles-menu-fluxbox
	doins "${FILESDIR}"/styles-menu-commonbox
	doins "${FILESDIR}"/styles-menu-user
}
