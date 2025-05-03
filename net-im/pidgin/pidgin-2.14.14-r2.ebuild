# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GENTOO_DEPEND_ON_PERL=no
PYTHON_COMPAT=( python3_{10..13} )

inherit autotools gnome2-utils flag-o-matic perl-module python-single-r1 xdg

DESCRIPTION="GTK Instant Messenger client"
HOMEPAGE="https://pidgin.im/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0/2" # libpurple version
KEYWORDS="~alpha amd64 arm arm64 ~loong ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="aqua dbus debug doc eds gadu gnutls groupwise +gstreamer +gui idn
meanwhile ncurses networkmanager nls perl prediction python sasl spell tcl
test tk v4l +xscreensaver zephyr zeroconf"
RESTRICT="!test? ( test )"

# dbus requires python to generate C code for dbus bindings (thus DEPEND only).
# finch uses libgnt that links with libpython - {R,}DEPEND. But still there is
# no way to build dbus and avoid libgnt linkage with python. If you want this
# send patch upstream.
# purple-url-handler and purple-remote require dbus-python thus in reality we
# rdepend on python if dbus enabled. But it is possible to separate this dep.
RDEPEND="
	>=dev-libs/glib-2.16
	>=dev-libs/libxml2-2.6.18:=
	dbus? (
		>=dev-libs/dbus-glib-0.71
		>=sys-apps/dbus-0.90
		$(python_gen_cond_dep '
			dev-python/dbus-python[${PYTHON_USEDEP}]
		')
	)
	gadu? ( >=net-libs/libgadu-1.11.0 )
	gnutls? ( net-libs/gnutls:= )
	!gnutls? (
		dev-libs/nspr
		dev-libs/nss
	)
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		>=net-libs/farstream-0.2.7:0.2
	)
	gui? (
		>=x11-libs/gtk+-2.10:2[aqua=]
		x11-libs/libSM
		>=x11-libs/pango-1.4.0
		xscreensaver? ( x11-libs/libXScrnSaver )
		spell? ( >=app-text/gtkspell-2.0.2:2 )
		eds? ( >=gnome-extra/evolution-data-server-3.6:= )
		prediction? ( >=dev-db/sqlite-3.3:3 )
	)
	idn? ( net-dns/libidn:= )
	meanwhile? ( net-libs/meanwhile )
	ncurses? (
		>=dev-libs/libgnt-$(ver_cut 1-2)
		sys-libs/ncurses:=[unicode(+)]
		dbus? ( ${PYTHON_DEPS} )
		python? ( ${PYTHON_DEPS} )
	)
	networkmanager? ( net-misc/networkmanager )
	perl? ( >=dev-lang/perl-5.16:= )
	sasl? ( dev-libs/cyrus-sasl:2 )
	tcl? ( dev-lang/tcl:0= )
	tk? ( dev-lang/tk:0= )
	v4l? ( media-plugins/gst-plugins-v4l2 )
	zeroconf? ( net-dns/avahi[dbus] )
"

# We want nls in case gtk is enabled, bug #
NLS_DEPEND="
	>=dev-util/intltool-0.41.1
	sys-devel/gettext
"
DEPEND="
	${RDEPEND}
	gui? (
		x11-base/xorg-proto
		${NLS_DEPEND}
	)
	dbus? ( ${PYTHON_DEPS} )
"
BDEPEND="
	dev-lang/perl
	dev-perl/XML-Parser
	virtual/pkgconfig
	doc? ( app-text/doxygen )
	!gui? ( nls? ( ${NLS_DEPEND} ) )
	test? ( >=dev-libs/check-0.9.4 )
"

DOCS=( AUTHORS HACKING NEWS README ChangeLog )

REQUIRED_USE="
	dbus? ( ${PYTHON_REQUIRED_USE} )
	networkmanager? ( dbus )
	python? ( ${PYTHON_REQUIRED_USE} )
	v4l? ( gstreamer )
"

# Enable Default protocols
DEFAULT_PRPLS="irc,jabber,simple"

# List of plugins
#   net-im/purple-events
#   x11-plugins/guifications
#   x11-plugins/pidgin-birthday-reminder
#   x11-plugins/pidgin-bot-sentry
#   x11-plugins/pidgin-encryption
#   x11-plugins/pidgin-extprefs
#   x11-plugins/pidgin-gnome-keyring
#   x11-plugins/pidgin-gpg
#   x11-plugins/pidgin-hotkeys
#   x11-plugins/pidgin-indicator
#   x11-plugins/pidgin-led-notification
#   x11-plugins/pidgin-libnotify
#   x11-plugins/pidgin-mbpurple
#   x11-plugins/pidgin-mpris
#   x11-plugins/pidgin-musictracker
#   x11-plugins/pidgin-opensteamworks
#   x11-plugins/pidgin-otr
#   x11-plugins/pidgin-privacy-please
#   x11-plugins/pidgin-sipe
#   x11-plugins/pidgin-skypeweb
#   x11-plugins/pidgin-window_merge
#   x11-plugins/pidgin-xmpp-receipts
#   x11-plugins/purple-libnotify-plus
#   x11-themes/pidgin-penguin-smileys
# Plugins in GURU:
#   x11-plugins/purple-mm-sms
# Plugins in overlays:
#   x11-plugins/g15purple
#   x11-plugins/lurch
#   x11-plugins/pidgin-awayonlock
#   x11-plugins/pidgin-battlenet
#   x11-plugins/pidgin-carbons
#   x11-plugins/pidgin-instagram
#   x11-plugins/pidgin-libbnet
#   x11-plugins/pidgin-slack
#   x11-plugins/pidgin-tlen
#   x11-plugins/pidgin-twisted-encoding
#   x11-plugins/pidgin-vk-plugin
#   x11-plugins/pidgin-whatsapp
#   x11-plugins/purple-discord
#   x11-plugins/purple-googlechat
#   x11-plugins/purple-matrix
#   x11-plugins/tdlib-purple

pkg_pretend() {
	if ! use gui && ! use ncurses ; then
		elog "You did not pick the ncurses or gui use flags, only libpurple"
		elog "will be built."
	fi

	# dbus is enabled, no way to disable linkage with python => python is enabled
	#REQUIRED_USE="gui? ( nls ) dbus? ( python )"
	if use gui && ! use nls ; then
		ewarn "gui build => nls is enabled!"
	fi
	if use dbus && ! use python ; then
		elog "dbus is enabled, no way to disable linkage with python => python is enabled"
	fi
}

pkg_setup() {
	if use python || use dbus ; then
		python-single-r1_pkg_setup
	fi
}

src_prepare() {
	xdg_environment_reset
	default
	eautoreconf
}

src_configure() {
	# bug #944076 (check if we can remove it w/ 3.x)
	append-cflags -std=gnu17

	use gadu 	&& DEFAULT_PRPLS+=",gg"
	use groupwise 	&& DEFAULT_PRPLS+=",novell"
	use meanwhile 	&& DEFAULT_PRPLS+=",sametime"
	use zephyr 	&& DEFAULT_PRPLS+=",zephyr"
	use zeroconf 	&& DEFAULT_PRPLS+=",bonjour"

	local myconf=(
		--disable-mono
		--disable-static
		# Don't downgrade F_S, we already set it in toolchain, bug #890276
		--disable-fortify
		--with-dynamic-prpls="${DEFAULT_PRPLS}"
		--with-system-ssl-certs="${EPREFIX}/etc/ssl/certs/"
		--x-includes="${EPREFIX}"/usr/include/X11
		$(use_enable dbus)
		$(use_enable debug)
		$(use_enable doc doxygen)
		$(use_enable gstreamer)
		$(use_enable gui gtkui)
		$(use_enable gui sm)
		$(use_enable idn)
		$(use_enable meanwhile)
		$(use_enable networkmanager nm)
		$(use_enable ncurses consoleui)
		$(use_enable perl)
		$(use_enable sasl cyrus-sasl )
		$(use_enable tk)
		$(use_enable tcl)
		$(use_enable v4l farstream)
		$(use_enable v4l gstreamer-video)
		$(use_enable v4l vv)
		$(use_enable zeroconf avahi)
		$(use_with gstreamer gstreamer 1.0)
		$(usex gui '--enable-nls' "$(use_enable nls)")
		$(use gui && use_enable eds gevolution)
		$(use gui && use_enable prediction cap)
		$(use gui && use_enable spell gtkspell)
		$(use gui && use_enable xscreensaver screensaver)
	)

	if use gnutls ; then
		einfo "Disabling NSS, using GnuTLS"
		myconf+=(
			--enable-gnutls=yes
			--enable-nss=no
			--with-gnutls-includes="${EPREFIX}/usr/include/gnutls"
			--with-gnutls-libs="${EPREFIX}/usr/$(get_libdir)"
		)
	else
		einfo "Disabling GnuTLS, using NSS"
		myconf+=(
			--enable-gnutls=no
			--enable-nss=yes
		)
	fi

	if use dbus || { use ncurses && use python ; } ; then
		myconf+=( --with-python3=${PYTHON} )
	else
		myconf+=( --without-python3 )
	fi
	# set variable to prevent configure script from calling gconftool-2
	GCONF_SCHEMA_INSTALL_SOURCE=/etc/gconf/schemas econf "${myconf[@]}"
}

src_install() {
	# setting this here because we no longer use gnome2.eclass
	export GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL="1"
	default

	if use gui ; then
		# Fix tray paths for e16 (x11-wm/enlightenment) and other
		# implementations that are not compliant with new hicolor theme yet, #323355
		local d f pixmapdir
		for d in 16 22 32 48 ; do
			pixmapdir="${ED}/usr/share/pixmaps/pidgin/tray/hicolor/${d}x${d}/actions"
			mkdir "${pixmapdir}" || die
			pushd "${pixmapdir}" >/dev/null || die
			for f in ../status/*; do
				ln -s ${f} || die
			done
			popd >/dev/null || die
		done
	fi
	use perl && perl_delete_localpod

	use dbus && python_fix_shebang "${ED}"
	if use python || use dbus ; then
		python_optimize
	fi

	dodoc ${DOCS[@]} finch/plugins/pietray.py
	docompress -x /usr/share/doc/${PF}/pietray.py

	find "${ED}" -type f -name "*.la" -delete || die
}

src_test() {
	# make default build logs slightly more useful
	local -x GST_PLUGIN_SYSTEM_PATH_1_0=
	emake check VERBOSE=1
}

pkg_preinst() {
	gnome2_gconf_savelist
	xdg_pkg_preinst
}

pkg_postinst() {
	gnome2_gconf_install
	gnome2_schemas_update
	xdg_pkg_postinst
}

pkg_postrm() {
	gnome2_gconf_uninstall
	gnome2_schemas_update
	xdg_pkg_postrm
}
