# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
inherit autotools eutils multilib elisp-common gnome2-utils

DESCRIPTION="Simple, secure and flexible input method library"
HOMEPAGE="https://github.com/uim/uim/"
SRC_URI="https://uim.googlecode.com/files/${P}.tar.bz2"

LICENSE="BSD GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
IUSE="+anthy canna curl eb emacs expat libffi gtk gtk3 kde libedit libnotify libressl m17n-lib ncurses nls qt4 skk sqlite ssl static-libs test unicode X xft l10n_ja l10n_ko l10n_zh-CN l10n_zh-TW"

RESTRICT="test"

REQUIRED_USE="gtk? ( X ) qt4? ( X )"

RDEPEND="X? (
		x11-libs/libX11
		x11-libs/libXft
		x11-libs/libXt
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libXext
		x11-libs/libXrender
	)
	anthy? (
		unicode? ( >=app-i18n/anthy-8622 )
		!unicode? ( app-i18n/anthy )
	)
	canna? ( app-i18n/canna )
	curl? ( >=net-misc/curl-7.16.4 )
	eb? ( dev-libs/eb )
	emacs? ( virtual/emacs )
	expat? ( dev-libs/expat )
	libffi? ( virtual/libffi )
	gtk? ( >=x11-libs/gtk+-2.4:2 )
	gtk3? ( x11-libs/gtk+:3 )
	kde? ( >=kde-base/kdelibs-4 )
	libedit? ( dev-libs/libedit )
	libnotify? ( >=x11-libs/libnotify-0.4 )
	m17n-lib? ( >=dev-libs/m17n-lib-1.3.1 )
	ncurses? ( sys-libs/ncurses:0= )
	nls? ( virtual/libintl )
	qt4? ( dev-qt/qtgui:4[qt3support] )
	skk? ( app-i18n/skk-jisyo )
	sqlite? ( dev-db/sqlite:3 )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	!dev-scheme/sigscheme"
#	scim? ( >=app-i18n/scim-1.3.0 ) # broken
#	wnn? ( app-i18n/wnn )

DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	>=sys-devel/gettext-0.15
	kde? ( dev-util/cmake )
	X? (
		x11-proto/xextproto
		x11-proto/xproto
	)"

RDEPEND="${RDEPEND}
	X? (
		media-fonts/font-sony-misc
		l10n_ja? ( || ( media-fonts/font-jis-misc media-fonts/intlfonts ) )
		l10n_ko? ( || ( media-fonts/font-daewoo-misc media-fonts/intlfonts ) )
		l10n_zh-CN? ( || ( media-fonts/font-isas-misc media-fonts/intlfonts ) )
		l10n_zh-TW? ( media-fonts/intlfonts )
	)"
#	test? ( dev-scheme/gauche )

SITEFILE=50${PN}-gentoo.el

pkg_setup() {
	strip-linguas fr ja ko
	if [[ -z "${LINGUAS}" ]]; then
		# no linguas set, using the default one
		LINGUAS=" "
	fi
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-1.6.0-gentoo.patch \
		"${FILESDIR}"/${PN}-1.5.4-zhTW.patch \
		"${FILESDIR}"/${P}-libressl.patch

	# bug 275420
	sed -i -e "s:\$libedit_path/lib:/$(get_libdir):g" configure.ac || die "sed failed!"

	AT_NO_RECURSIVE=1 eautoreconf
}

src_configure() {
	local myconf

	if (use gtk || use gtk3) && (use anthy || use canna) ; then
		myconf="${myconf} --enable-dict"
	else
		myconf="${myconf} --disable-dict"
	fi

	if use gtk || use gtk3 || use qt4 ; then
		myconf="${myconf} --enable-pref"
	else
		myconf="${myconf} --disable-pref"
	fi

	if use anthy ; then
		if use unicode ; then
			myconf="${myconf} --with-anthy-utf8"
		else
			myconf="${myconf} --with-anthy"
		fi
	else
		myconf="${myconf} --without-anthy"
	fi

	if use libnotify ; then
		myconf="${myconf} --enable-notify=libnotify"
	fi

	econf $(use_with X x) \
		$(use_with canna) \
		$(use_with curl) \
		$(use_with eb) \
		$(use_enable emacs) \
		$(use_with emacs lispdir "${SITELISP}") \
		$(use_with expat) \
		$(use_with libffi ffi) \
		--disable-gnome-applet \
		$(use_with gtk gtk2) \
		$(use_with gtk3) \
		$(use_with libedit) \
		--disable-kde-applet \
		$(use_enable kde kde4-applet) \
		$(use_with m17n-lib m17nlib) \
		$(use_enable ncurses fep) \
		$(use_enable nls) \
		--without-qt \
		--without-qt-immodule \
		$(use_with qt4 qt4) \
		$(use_with qt4 qt4-immodule) \
		$(use_enable qt4 qt4-qt3support) \
		$(use_with skk) \
		$(use_with sqlite sqlite3) \
		$(use_enable ssl openssl) \
		$(use_enable static-libs static) \
		$(use_with xft) \
		${myconf}
}

src_compile() {
	default

	if use emacs; then
		cd emacs
		elisp-compile *.el || die "elisp-compile failed!"
	fi
}

src_install() {
	# parallel make install b0rked, bug #222677
	emake -j1 INSTALL_ROOT="${D}" DESTDIR="${D}" install

	dodoc AUTHORS ChangeLog* NEWS README RELNOTE
	if use emacs; then
		elisp-install uim-el emacs/*.elc || die "elisp-install failed!"
		elisp-site-file-install "${FILESDIR}/${SITEFILE}" uim-el \
			|| die "elisp-site-file-install failed!"
	fi

	find "${ED}/usr/$(get_libdir)/uim" -name '*.la' -exec rm {} +
	use static-libs || find "${ED}" -name '*.la' -exec rm {} +

	sed -e "s:@EPREFIX@:${EPREFIX}:" "${FILESDIR}/xinput-uim" > "${T}/uim.conf" || die "sed failed!"
	insinto /etc/X11/xinit/xinput.d
	doins "${T}/uim.conf"

	# collision with dev-scheme/sigscheme, bug #330975
	# find "${ED}" -name '*gcroots*' -delete || die

	#rmdir "${ED}"/usr/share/doc/sigscheme || die
}

pkg_postinst() {
	elog
	elog "New input method switcher has been introduced. You need to set"
	elog
	elog "% GTK_IM_MODULE=uim ; export GTK_IM_MODULE"
	elog "% QT_IM_MODULE=uim ; export QT_IM_MODULE"
	elog "% XMODIFIERS=@im=uim ; export XMODIFIERS"
	elog
	elog "If you would like to use uim-anthy as default input method, put"
	elog "(define default-im-name 'anthy)"
	elog "to your ~/.uim."
	elog
	elog "All input methods can be found by running uim-im-switcher-gtk, "
	elog "uim-im-switcher-gtk3 or uim-im-switcher-qt4."
	elog
	elog "If you upgrade from a version of uim older than 1.4.0,"
	elog "you should run revdep-rebuild."

	use gtk && gnome2_query_immodules_gtk2
	use gtk3 && gnome2_query_immodules_gtk3
	if use emacs; then
		elisp-site-regen
		echo
		elog "uim is autoloaded with Emacs with a minimal set of features:"
		elog "There is no keybinding defined to call it directly, so please"
		elog "create one yourself and choose an input method."
		elog "Integration with LEIM is not done with this ebuild, please have"
		elog "a look at the documentation how to achieve this."
	fi
}

pkg_postrm() {
	use gtk && gnome2_query_immodules_gtk2
	use gtk3 && gnome2_query_immodules_gtk3
	use emacs && elisp-site-regen
}
