# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit autotools dot-a elisp-common flag-o-matic gnome2-utils qmake-utils xdg

DESCRIPTION="Multilingual input method framework"
HOMEPAGE="https://github.com/uim/uim"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PV}/${P}.tar.bz2"

LICENSE="BSD GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~riscv ~x86"
IUSE="X +anthy curl eb emacs expat libffi gtk gtk2 l10n_ja l10n_ko l10n_zh-CN l10n_zh-TW libedit libnotify m17n-lib ncurses qt5 qt6 skk sqlite ssl static-libs"
RESTRICT="test"
REQUIRED_USE="
	gtk? ( X )
	gtk2? ( X )
	qt5? ( X )
	qt6? ( X )
"
GTK_DEPEND="
	dev-libs/glib:2
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/pango
"
COMMON_DEPEND="
	virtual/libintl
	X? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXft
	)
	anthy? ( app-i18n/anthy-unicode )
	curl? ( net-misc/curl )
	eb? ( dev-libs/eb )
	emacs? ( >=app-editors/emacs-23.1:* )
	expat? ( dev-libs/expat )
	gtk? (
		${GTK_DEPEND}
		x11-libs/gtk+:3[X]
	)
	gtk2? (
		${GTK_DEPEND}
		x11-libs/gtk+:2
	)
	libedit? ( dev-libs/libedit )
	libffi? ( dev-libs/libffi:= )
	libnotify? (
		dev-libs/glib:2
		x11-libs/libnotify
	)
	m17n-lib? ( dev-libs/m17n-lib )
	ncurses? ( sys-libs/ncurses:0= )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtx11extras:5
		dev-qt/qtwidgets:5
	)
	qt6? ( dev-qt/qtbase:6[widgets,X] )
	skk? ( app-i18n/skk-jisyo )
	sqlite? ( dev-db/sqlite:3 )
	ssl? ( dev-libs/openssl:0= )
"
DEPEND="
	${COMMON_DEPEND}
	X? (
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libXrender
		x11-libs/libXt
		x11-base/xorg-proto
	)
"
RDEPEND="
	${COMMON_DEPEND}
	!dev-scheme/sigscheme
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
	)
"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-zh-TW.patch

	# PR merged https://github.com/uim/uim/pull/274.patch
	"${FILESDIR}"/${P}-missing_includes.patch
	"${FILESDIR}"/${P}-skk.patch
	"${FILESDIR}"/${PN}-kde.patch
	"${FILESDIR}"/${PN}-tinfo.patch
	"${FILESDIR}"/${PN}-xkb.patch
	# PR merged https://github.com/uim/uim/pull/275.patch
	"${FILESDIR}"/${P}-pkg_config.patch
)

DOCS=( AUTHORS NEWS README RELNOTE doc )

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	default
	sed -i "s:\$libedit_path/lib:/$(get_libdir):g" configure.ac || die

	# Fix build w/ Clang 16+ and >= openssl 1.1.x, tries to use
	# SSLv2_method otherwise.
	append-cppflags -DOPENSSL_NO_SSL2

	eautoreconf
}

src_configure() {
	use static-libs && lto-guarantee-fat

	# mask gosh, checked for the unavailable unit-test #884321
	export ac_cv_path_GOSH=

	# order of preference
	TOOLKIT=(
		$(usev gtk gtk3)
		$(usev qt6)
		$(usev gtk2 gtk)
		$(usev qt5)
	)

	local myconf=(
		$(use_with X x)
		$(use_with X xft)
		$(use_with anthy anthy-utf8)
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
		$(use_with qt5)
		$(use_with qt5 qt5-immodule)
		_QMAKE5=$(qt5_get_bindir)/qmake
		$(use_with qt6)
		$(use_with qt6 qt6-immodule)
		_QMAKE6=$(qt6_get_bindir)/qmake
		$(use_with skk)
		$(use_with sqlite sqlite3)
		$(use_enable ssl openssl)
		$(use_enable static-libs static)
		--enable-nls
		--enable-default-toolkit="${TOOLKIT[0]}"
		--disable-gnome-applet
		--disable-gnome3-applet
		--disable-kde5-applet
		--without-mana
		--without-anthy
		--without-canna
		--without-prime
	)

	if (use gtk || use gtk2) && use anthy; then
		myconf+=( --enable-dict )
	else
		myconf+=( --disable-dict )
	fi

	if use libnotify; then
		myconf+=( --enable-notify=libnotify )
	fi

	if [[ -n "${TOOLKIT[@]}" ]]; then
		myconf+=( --enable-pref )
	else
		myconf+=( --disable-pref )
	fi

	econf "${myconf[@]}"
}

src_compile() {
	default

	if use emacs; then
		pushd emacs >/dev/null || die
		elisp-compile *.el || die
		popd >/dev/null || die
	fi
}

src_install() {
	# bug #222677
	emake -j1 DESTDIR="${D}" install
	rm -f doc/Makefile*
	einstalldocs

	find "${ED}"/usr/$(get_libdir)/${PN} -name '*.la' -delete || die

	if use static-libs; then
		strip-lto-bytecode
	else
		find "${ED}" -name '*.la' -delete || die
	fi

	insinto /etc/X11/xinit/xinput.d
	sed \
		-e "s:@EPREFIX@:${EPREFIX}:g" \
		"${FILESDIR}"/xinput-${PN} > "${T}"/${PN}.conf || die
	doins "${T}"/${PN}.conf

	if use X; then
		docinto xim
		dodoc xim/README*
	fi

	if use emacs; then
		elisp-install ${PN}-el emacs/*.el{,c}
		elisp-site-file-install "${FILESDIR}"/${SITEFILE} ${PN}-el
		docinto emacs
		dodoc emacs/README*
	fi

	if use ncurses; then
		docinto fep
		dodoc fep/README*
	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	elog " "
	elog "uim is defined as an input method on X into ${EROOT}/etc/X11/xinit/xinput.d/uim.conf"
	elog "However, you may need to set anyway:"
	elog "  % GTK_IM_MODULE=uim ; export GTK_IM_MODULE"
	elog "  % QT_IM_MODULE=uim ; export QT_IM_MODULE"
	elog "  % XMODIFIERS=@im=uim ; export XMODIFIERS"

	elog " "
	elog "User preferences are defined by:"
	elog "editing ~/.uim"
	if use anthy; then
		elog "  e.g. to use uim-anthy-utf8 as default input method, put"
		elog "  (define default-im-name 'anthy-utf8)"
	fi
	if [[ -n "${TOOLKIT[@]}" ]]; then
		elog "or running GUIs:"
		elog "$(printf "  %s\n" "${TOOLKIT[@]/#/uim-pref-}")"
		elog " "
		elog "Input methods are available by running:"
		elog "$(printf "  %s\n" "${TOOLKIT[@]/#/uim-im-switcher-}")"
	fi

	if use emacs; then
		elisp-site-regen
		elog " "
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
