# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/gnupg.asc
inherit autotools qmake-utils verify-sig

DESCRIPTION="Simple passphrase entry dialogs which utilize the Assuan protocol"
HOMEPAGE="https://gnupg.org/related_software/pinentry/"
SRC_URI="mirror://gnupg/${PN}/${P}.tar.bz2"
SRC_URI+=" verify-sig? ( mirror://gnupg/${PN}/${P}.tar.bz2.sig )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="caps efl emacs gtk keyring ncurses qt5 qt6 wayland X"

DEPEND="
	>=dev-libs/libassuan-2.1
	>=dev-libs/libgcrypt-1.6.3
	>=dev-libs/libgpg-error-1.17
	efl? ( dev-libs/efl[X] )
	keyring? ( app-crypt/libsecret )
	ncurses? ( sys-libs/ncurses:= )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		wayland? ( kde-plasma/kwayland:5 )
		X? (
			dev-qt/qtx11extras:5
			x11-libs/libX11
		)
	)
	qt6? (
		dev-qt/qtbase:6[gui,widgets]
		wayland? (
			kde-frameworks/kguiaddons:6
			kde-frameworks/kwindowsystem:6
		)
	)
"
RDEPEND="
	${DEPEND}
	gtk? ( app-crypt/gcr:4[gtk] )
"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
	verify-sig? ( sec-keys/openpgp-keys-gnupg )
"
PDEPEND="emacs? ( app-emacs/pinentry )"
IDEPEND=">=app-eselect/eselect-pinentry-0.7.4"

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )

PATCHES=(
	"${FILESDIR}/${PN}-1.0.0-AR.patch"
	"${FILESDIR}/${PN}-1.3.0-automagic.patch" # bug #819939, bug #837719
	"${FILESDIR}/${PN}-1.3.0-ifdef-qt.patch"
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	unset FLTK_CONFIG

	local myeconfargs=(
		$(use_enable efl pinentry-efl)
		$(use_enable emacs pinentry-emacs)
		$(use_enable keyring libsecret)
		$(use_enable gtk pinentry-gnome3)
		$(use_enable ncurses fallback-curses)
		$(use_enable ncurses pinentry-curses)
		$(use_enable qt5 pinentry-qt5)
		$(use_enable qt6 pinentry-qt)
		# TODO: could split this up into qt5/qt6?
		$(use_enable X qtx11extras)
		$(use_with X x)

		--enable-pinentry-tty
		--disable-pinentry-fltk
		--disable-pinentry-gtk2

		ac_cv_path_GPGRT_CONFIG="${ESYSROOT}/usr/bin/${CHOST}-gpgrt-config"

		$("${S}/configure" --help | grep -- '--without-.*-prefix' | sed -e 's/^ *\([^ ]*\) .*/\1/g')
	)

	if use qt5 ; then
		export PATH="$(qt5_get_bindir):${PATH}"
		export QTLIB="$(qt5_get_libdir):${QTLIB}"
		export MOC5="$(qt5_get_bindir)"/moc

		myeconfargs+=(
			$(use_enable wayland kf5-wayland)
		)
	else
		myeconfargs+=(
			--disable-kf5-wayland
		)
	fi

	if use qt6 ; then
		export PATH="$(qt6_get_bindir):${PATH}"
		export QTLIB="$(qt6_get_libdir):${QTLIB}"
		export MOC="$(qt6_get_libdir)/qt6/libexec/moc"

		myeconfargs+=(
			$(use_enable wayland kf6-wayland)
		)
	else
		myeconfargs+=(
			--disable-kf6-wayland
		)
	fi

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	rm "${ED}"/usr/bin/pinentry || die

	if use qt6 ; then
		dosym pinentry-qt /usr/bin/pinentry-qt6
	elif use qt5 ; then
		dosym pinentry-qt /usr/bin/pinentry-qt5
	fi
}

pkg_postinst() {
	eselect pinentry update ifunset
}

pkg_postrm() {
	eselect pinentry update ifunset
}
