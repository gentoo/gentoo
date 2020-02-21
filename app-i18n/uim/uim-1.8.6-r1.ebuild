# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools elisp-common gnome2-utils qmake-utils

DESCRIPTION="A multilingual input method framework"
HOMEPAGE="https://github.com/uim/uim"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${P}/${P}.tar.bz2"

LICENSE="BSD GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ppc ppc64 x86"
IUSE="X +anthy canna curl eb emacs expat libffi gtk gtk2 l10n_ja l10n_ko l10n_zh-CN l10n_zh-TW libedit libnotify m17n-lib ncurses nls skk sqlite ssl static-libs xft"
RESTRICT="test"
REQUIRED_USE="gtk? ( X )
	gtk2? ( X )
	xft? ( X )"

CDEPEND="!dev-scheme/sigscheme
	X? (
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXft
		x11-libs/libXrender
		x11-libs/libXt
	)
	anthy? ( app-i18n/anthy )
	canna? ( app-i18n/canna )
	curl? ( net-misc/curl )
	eb? ( dev-libs/eb )
	emacs? ( >=app-editors/emacs-23.1:* )
	expat? ( dev-libs/expat )
	libffi? ( virtual/libffi )
	gtk? ( x11-libs/gtk+:3 )
	gtk2? ( x11-libs/gtk+:2 )
	libedit? ( dev-libs/libedit )
	libnotify? ( x11-libs/libnotify )
	m17n-lib? ( dev-libs/m17n-lib )
	ncurses? ( sys-libs/ncurses:0= )
	nls? ( virtual/libintl )
	skk? ( app-i18n/skk-jisyo )
	sqlite? ( dev-db/sqlite:3 )
	ssl? ( dev-libs/openssl:0 )"
DEPEND="${CDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	X? ( x11-base/xorg-proto )"
RDEPEND="${CDEPEND}
	X? (
		media-fonts/font-sony-misc
		l10n_ja? (
			|| (
				media-fonts/font-jis-misc
				media-fonts/intlfonts
			)
		)
		l10n_ko? (
			|| (
				media-fonts/font-daewoo-misc
				media-fonts/intlfonts
			)
		)
		l10n_zh-CN? (
			|| (
				media-fonts/font-isas-misc
				media-fonts/intlfonts
			)
		)
		l10n_zh-TW? ( media-fonts/intlfonts )
	)"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-qt.patch
	"${FILESDIR}"/${P}-tinfo.patch
	"${FILESDIR}"/${PN}-zh-TW.patch
)
DOCS=( AUTHORS NEWS README RELNOTE )

AT_NO_RECURSIVE="yes"
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	default
	sed -i "s:\$libedit_path/lib:/$(get_libdir):g" configure.ac

	eautoreconf
}

src_configure() {
	local myconf=(
		$(use_with X x)
		$(use_with anthy anthy-utf8)
		$(use_with canna)
		$(use_with curl)
		$(use_with eb)
		$(use_enable emacs)
		$(use_with emacs lispdir "${SITELISP}")
		$(use_with expat)
		$(use_with libedit)
		$(use_with libffi ffi)
		$(use_with gtk gtk3)
		$(use_with gtk2)
		$(use_with m17n-lib m17nlib)
		$(use_enable ncurses fep)
		$(use_enable nls)
		--without-qt4
		--without-qt4-immodule
		--disable-qt4-qt3support
		$(use_with skk)
		$(use_with sqlite sqlite3)
		$(use_enable ssl openssl)
		$(use_enable static-libs static)
		$(use_with xft)
		--without-anthy
		--enable-default-toolkit=$(usex gtk gtk3 $(usex gtk2 gtk))
		--disable-gnome-applet
		--disable-gnome3-applet
		--disable-kde-applet
		--disable-kde4-applet
		--without-mana
		--without-prime
	)

	if (use gtk || use gtk2) && (use anthy || use canna); then
		myconf+=( --enable-dict )
	else
		myconf+=( --disable-dict )
	fi

	if use libnotify; then
		myconf+=( --enable-notify=libnotify )
	fi

	if use gtk || use gtk2; then
		myconf+=( --enable-pref )
	else
		myconf+=( --disable-pref )
	fi

	econf "${myconf[@]}"
}

src_compile() {
	default

	if use emacs; then
		cd emacs
		elisp-compile *.el || die
	fi
}

src_install() {
	# bug #222677
	emake -j1 DESTDIR="${D}" install
	einstalldocs

	find "${ED}"/usr/$(get_libdir)/${PN} -name '*.la' -delete || die
	use static-libs || find "${ED}" -name '*.la' -delete || die

	insinto /etc/X11/xinit/xinput.d
	sed \
		-e "s:@EPREFIX@:${EPREFIX}:g" \
		"${FILESDIR}"/xinput-${PN} > "${T}"/${PN}.conf
	doins "${T}"/${PN}.conf

	if use emacs; then
		elisp-install ${PN}-el emacs/*.el{,c}
		elisp-site-file-install "${FILESDIR}"/${SITEFILE} ${PN}-el
	fi
}

pkg_postinst() {
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
	elog "uim-im-switcher-gtk3."

	if use emacs; then
		elisp-site-regen
		echo
		elog "uim is autoloaded with Emacs with a minimal set of features:"
		elog "There is no keybinding defined to call it directly, so please"
		elog "create one yourself and choose an input method."
		elog "Integration with LEIM is not done with this ebuild, please have"
		elog "a look at the documentation how to achieve this."
	fi
	use gtk && gnome2_query_immodules_gtk3
	use gtk2 && gnome2_query_immodules_gtk2
}

pkg_postrm() {
	use emacs && elisp-site-regen
	use gtk && gnome2_query_immodules_gtk3
	use gtk2 && gnome2_query_immodules_gtk2
}
