# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools flag-o-matic desktop

DESCRIPTION="An extremely powerful ICCCM-compliant multiple virtual desktop window manager"
HOMEPAGE="http://www.fvwm.org/"
SRC_URI="https://github.com/fvwmorg/fvwm/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2 FVWM"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="bidi debug doc netpbm nls perl png readline rplay stroke svg tk truetype +vanilla xinerama lock"

COMMON_DEPEND="
	sys-libs/zlib
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXcursor
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXpm
	x11-libs/libXrandr
	x11-libs/libXrender
	virtual/libiconv
	bidi? ( dev-libs/fribidi )
	nls? ( virtual/libintl )
	png? ( media-libs/libpng:0= )
	readline? (
		sys-libs/ncurses:0=
		sys-libs/readline:0=
	)
	stroke? ( dev-libs/libstroke )
	svg? ( gnome-base/librsvg )
	truetype? (
		media-libs/fontconfig
		x11-libs/libXft
	)
	xinerama? ( x11-libs/libXinerama )
"
RDEPEND="${COMMON_DEPEND}
	dev-lang/perl
	perl? ( tk? (
			dev-lang/tk
			dev-perl/Tk
			>=dev-perl/X11-Protocol-0.56
		)
	)
	rplay? ( media-sound/rplay )
	lock? ( x11-misc/xlockmore )
	userland_GNU? ( sys-apps/debianutils )
	!x86-fbsd? ( netpbm? ( media-libs/netpbm ) )
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	x11-base/xorg-proto
	doc? ( dev-libs/libxslt )
"

src_prepare() {
	if ! use vanilla; then
		# Enables fast translucent menus; patch from fvwm-user mailing list.
		eapply -p0 "${FILESDIR}/${PN}-2.5.27-translucent-menus.diff"

		# Allow more mouse buttons, bug #411811
		eapply -p0 "${FILESDIR}/${PN}-2.6.5-mouse-buttons.patch"
	fi

	eapply -p0 "${FILESDIR}/${PN}-2.6.5-ar.patch" #474528

	# Fix for Perl 5.28
	eapply -p0 "${FILESDIR}/${PN}-2.6.8-perl528.patch"

	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--libexecdir="${EPREFIX}"/usr/$(get_libdir)
		--with-imagepath=/usr/include/X11/bitmaps:/usr/include/X11/pixmaps:/usr/share/icons/fvwm
		--enable-iconv
		--enable-package-subdirs
		$(use_enable bidi)
		$(use_enable debug debug-msgs)
		$(use_enable debug command-log)
		$(use_enable doc htmldoc)
		$(use_enable nls)
		$(use_enable perl perllib)
		$(use_enable png)
		$(use_with readline readline-library)
		$(use_with rplay rplay-library)
		$(use_with stroke stroke-library)
		$(use_enable svg rsvg)
		$(use_enable truetype xft)
		$(use_enable xinerama)
	)

	# Non-upstream email where bugs should be sent; used in fvwm-bug.
	export FVWM_BUGADDR="maintainer-needed@gentoo.org"

	# Recommended by upstream, reference ????
	append-flags -fno-strict-aliasing

	# Signed chars are required.
	use ppc && append-flags -fsigned-char

	use readline && myeconfargs+=( --without-termcap-library )

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	make_session_desktop fvwm /usr/bin/fvwm

	if ! use lock; then
		find "${D}" -name '*fvwm-menu-xlock' -exec rm -f '{}' \; 2>/dev/null
	fi

	if use perl; then
		if ! use tk; then
			rm "${D}"/usr/share/fvwm/perllib/FVWM/Module/Tk.pm || die
			rm "${D}"/usr/share/fvwm/perllib/FVWM/Module/Toolkit.pm || die
			find "${D}"/usr/share/fvwm/perllib -depth -type d -exec rmdir '{}' \; 2>/dev/null
		fi
	else
		# Completely wipe it if ! use perl
		rm -r "${D}"/usr/bin/fvwm-perllib "${D}"/usr/share/man/man1/fvwm-perllib.1
	fi

	# Utility for testing FVWM behaviour by creating a simple window with
	# configurable hints.
	if use debug; then
		dobin "${S}"/tests/hints/hints_test
		newdoc "${S}"/tests/hints/README README.hints
	fi

	dodir /etc/X11/Sessions
	echo "/usr/bin/fvwm" > "${D}"/etc/X11/Sessions/${PN} || die
	fperms a+x /etc/X11/Sessions/${PN}

	dodoc docs/{COMMANDS,DEVELOPERS.md}

	# README file for translucent menus patch.
	if ! use vanilla; then
		dodoc "${FILESDIR}"/README.translucency
		ewarn "You are using a patched build, so, please, don't"
		ewarn "report bugs at the fvwm-workers list unless you are"
		ewarn "also able to reproduce them with a vanilla build (USE=vanilla)."
	fi
}
