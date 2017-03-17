# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GENTOO_DEPEND_ON_PERL=no
PYTHON_COMPAT=( python2_7 )

inherit autotools flag-o-matic gnome2 toolchain-funcs multilib perl-module python-single-r1

DESCRIPTION="GTK Instant Messenger client"
HOMEPAGE="http://pidgin.im/"
SRC_URI="
	mirror://sourceforge/${PN}/${P}.tar.bz2
	https://dev.gentoo.org/~polynomial-c/${PN}-eds-3.6.patch.bz2
	https://gist.githubusercontent.com/imcleod/77f38d11af11b2413ada/raw/46e9d6cb4d2f839832dad2d697bb141a88028e04/pidgin-irc-join-sleep.patch -> ${PN}-2.10.9-irc_join_sleep.patch"

LICENSE="GPL-2"
SLOT="0/2" # libpurple version
KEYWORDS="~alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="dbus debug doc eds gadu gnutls +gstreamer +gtk idn meanwhile pie"
IUSE+=" networkmanager nls perl silc tcl tk spell sasl ncurses"
IUSE+=" groupwise prediction python +xscreensaver zephyr zeroconf" # mono"
IUSE+=" aqua"

# dbus requires python to generate C code for dbus bindings (thus DEPEND only).
# finch uses libgnt that links with libpython - {R,}DEPEND. But still there is
# no way to build dbus and avoid libgnt linkage with python. If you want this
# send patch upstream.
# purple-url-handler and purple-remote require dbus-python thus in reality we
# rdepend on python if dbus enabled. But it is possible to separate this dep.
RDEPEND="
	>=dev-libs/glib-2.16
	>=dev-libs/libxml2-2.6.18
	ncurses? (
		sys-libs/ncurses:0=[unicode]
		dbus? ( ${PYTHON_DEPS} )
		python? ( ${PYTHON_DEPS} )
	)
	gtk? (
		>=x11-libs/gtk+-2.10:2[aqua=]
		x11-libs/libSM
		xscreensaver? ( x11-libs/libXScrnSaver )
		spell? ( >=app-text/gtkspell-2.0.2:2 )
		eds? ( >=gnome-extra/evolution-data-server-3.6:= )
		prediction? ( >=dev-db/sqlite-3.3:3 )
	)
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		>=net-libs/farstream-0.2.7:0.2
	)
	zeroconf? ( net-dns/avahi[dbus] )
	dbus? (
		>=dev-libs/dbus-glib-0.71
		>=sys-apps/dbus-0.90
		dev-python/dbus-python
	)
	perl? ( >=dev-lang/perl-5.16:= )
	gadu? (
		|| (
			>=net-libs/libgadu-1.11.0[ssl,gnutls]
			>=net-libs/libgadu-1.11.0[-ssl]
		)
	)
	gnutls? ( net-libs/gnutls )
	!gnutls? (
		dev-libs/nspr
		dev-libs/nss
	)
	meanwhile? ( net-libs/meanwhile )
	silc? ( >=net-im/silc-toolkit-1.0.1 )
	tcl? ( dev-lang/tcl:0= )
	tk? ( dev-lang/tk:0= )
	sasl? ( dev-libs/cyrus-sasl:2 )
	networkmanager? ( net-misc/networkmanager )
	idn? ( net-dns/libidn )
	!<x11-plugins/pidgin-facebookchat-1.69-r1"
	# Mono support crashes pidgin
	#mono? ( dev-lang/mono )"

# We want nls in case gtk is enabled, bug #
NLS_DEPEND=">=dev-util/intltool-0.41.1 sys-devel/gettext"

DEPEND="$RDEPEND
	dev-lang/perl
	dev-perl/XML-Parser
	virtual/pkgconfig
	gtk? (
		x11-proto/scrnsaverproto
		${NLS_DEPEND}
	)
	dbus? ( ${PYTHON_DEPS} )
	doc? ( app-doc/doxygen )
	!gtk? ( nls? ( ${NLS_DEPEND} ) )"

DOCS="AUTHORS HACKING NEWS README ChangeLog"

REQUIRED_USE="
	dbus? ( ${PYTHON_REQUIRED_USE} )
	networkmanager? ( dbus )
	python? ( ${PYTHON_REQUIRED_USE} )
"

# Enable Default protocols
DYNAMIC_PRPLS="irc,jabber,oscar,simple"

# List of plugins
#   app-accessibility/pidgin-festival
#   net-im/librvp
#   x11-plugins/guifications
#	x11-plugins/msn-pecan
#   x11-plugins/pidgin-encryption
#   x11-plugins/pidgin-extprefs
#   x11-plugins/pidgin-hotkeys
#   x11-plugins/pidgin-latex
#   x11-plugins/pidgintex
#   x11-plugins/pidgin-libnotify
#	x11-plugins/pidgin-mbpurple
#	x11-plugins/pidgin-bot-sentry
#   x11-plugins/pidgin-otr
#   x11-plugins/pidgin-rhythmbox
#   x11-plugins/purple-plugin_pack
#   x11-themes/pidgin-smileys
#	x11-plugins/pidgin-knotify
# Plugins in Sunrise:
#	x11-plugins/pidgin-audacious-remote
#	x11-plugins/pidgin-autoanswer
#	x11-plugins/pidgin-birthday-reminder
#	x11-plugins/pidgin-blinklight
#	x11-plugins/pidgin-convreverse
#	x11-plugins/pidgin-embeddedvideo
#	x11-plugins/pidgin-extended-blist-sort
#	x11-plugins/pidgin-gfire
#	x11-plugins/pidgin-lastfm
#	x11-plugins/pidgin-sendscreenshot
#	x11-plugins/pidgimpd

PATCHES=(
	"${FILESDIR}/${PN}-2.10.0-gold.patch"
	"${WORKDIR}/${PN}-eds-3.6.patch"
	"${FILESDIR}/${PN}-2.10.9-fix-gtkmedia.patch"
	"${FILESDIR}/${PN}-2.10.10-eds-3.6-configure.ac.patch"
	"${FILESDIR}/${PN}-2.10.11-tinfo.patch"
	"${DISTDIR}/${PN}-2.10.9-irc_join_sleep.patch" # 577286
)

pkg_setup() {
	if ! use gtk && ! use ncurses ; then
		elog "You did not pick the ncurses or gtk use flags, only libpurple"
		elog "will be built."
	fi
	if use python || use dbus ; then
		python-single-r1_pkg_setup
	fi

	# dbus is enabled, no way to disable linkage with python => python is enabled
	#REQUIRED_USE="gtk? ( nls ) dbus? ( python )"
	if use gtk && ! use nls; then
		ewarn "gtk build => nls is enabled!"
	fi
	if use dbus && ! use python; then
		elog "dbus is enabled, no way to disable linkage with python => python is enabled"
	fi
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# Stabilize things, for your own good
	strip-flags
	replace-flags -O? -O2
	use pie && append-cflags -fPIE -pie

	local myconf=()

	use gadu 	&& DYNAMIC_PRPLS+=",gg"
	use groupwise 	&& DYNAMIC_PRPLS+=",novell"
	use silc 	&& DYNAMIC_PRPLS+=",silc"
	use meanwhile 	&& DYNAMIC_PRPLS+=",sametime"
	use zephyr 	&& DYNAMIC_PRPLS+=",zephyr"
	use zeroconf 	&& DYNAMIC_PRPLS+=",bonjour"

	if use gnutls; then
		einfo "Disabling NSS, using GnuTLS"
		myconf+=( --enable-nss=no --enable-gnutls=yes )
		myconf+=( --with-gnutls-includes="${EPREFIX}/usr/include/gnutls" )
		myconf+=( --with-gnutls-libs="${EPREFIX}/usr/$(get_libdir)" )
	else
		einfo "Disabling GnuTLS, using NSS"
		myconf+=( --enable-gnutls=no --enable-nss=yes )
	fi

	if use dbus || { use ncurses && use python ; } ; then
		myconf+=( --with-python=${PYTHON} )
	else
		myconf+=( --without-python )
	fi

	local myeconfargs=(
		--disable-mono
		--with-dynamic-prpls="${DYNAMIC_PRPLS}"
		--with-system-ssl-certs="${EPREFIX}/etc/ssl/certs/"
		--x-includes="${EPREFIX}"/usr/include/X11
		$(use_enable ncurses consoleui)
		$(use_enable gtk gtkui)
		$(use_enable gtk sm)
		$(usex gtk '--enable-nls' "$(use_enable nls)")
		$(use gtk && use_enable xscreensaver screensaver)
		$(use gtk && use_enable prediction cap)
		$(use gtk && use_enable eds gevolution)
		$(use gtk && use_enable spell gtkspell)
		$(use_enable perl)
		$(use_enable tk)
		$(use_enable tcl)
		$(use_enable debug)
		$(use_enable dbus)
		$(use_enable meanwhile)
		$(use_enable gstreamer)
		$(use_with gstreamer gstreamer 1.0)
		$(use_enable gstreamer farstream)
		$(use_enable gstreamer vv)
		$(use_enable sasl cyrus-sasl )
		$(use_enable doc doxygen)
		$(use_enable networkmanager nm)
		$(use_enable zeroconf avahi)
		$(use_enable idn)
		${myconf[@]}
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	gnome2_src_install

	if use gtk; then
		# Fix tray pathes for e16 (x11-wm/enlightenment) and other
		# implementations that are not complient with new hicolor theme yet, #323355
		local pixmapdir
		for d in 16 22 32 48; do
			pixmapdir=${ED}/usr/share/pixmaps/pidgin/tray/hicolor/${d}x${d}/actions
			mkdir "${pixmapdir}" || die
			pushd "${pixmapdir}" >/dev/null || die
			for f in ../status/*; do
				ln -s ${f} || die
			done
			popd >/dev/null
		done
	fi
	use perl && perl_delete_localpod

	if use python && use dbus ; then
		python_fix_shebang "${D}"
		python_optimize
	fi

	dodoc ${DOCS} finch/plugins/pietray.py
	docompress -x /usr/share/doc/${PF}/pietray.py

	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die
}

src_test() {
	emake check
}
