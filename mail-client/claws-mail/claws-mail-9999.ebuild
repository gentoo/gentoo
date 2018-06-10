# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit autotools gnome2-utils python-single-r1 xdg-utils

DESCRIPTION="An email client (and news reader) based on GTK+"
HOMEPAGE="https://www.claws-mail.org/"

if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="git://git.claws-mail.org/claws.git"
else
	SRC_URI="https://www.claws-mail.org/download.php?file=releases/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

SLOT="0"
LICENSE="GPL-3"

IUSE="archive bogofilter calendar clamav dbus debug doc gdata +gnutls gtk3 +imap ipv6 ldap +libcanberra +libindicate +libnotify networkmanager nls nntp +notification pda pdf perl +pgp python rss session sieve smime spamassassin spam-report spell startup-notification svg valgrind xface"
REQUIRED_USE="libcanberra? ( notification )
	libindicate? ( notification )
	libnotify? ( notification )
	networkmanager? ( dbus )
	python? ( ${PYTHON_REQUIRED_USE} )
	smime? ( pgp )"

COMMONDEPEND="
	net-mail/ytnef
	archive? (
		app-arch/libarchive
		>=net-misc/curl-7.9.7
	)
	bogofilter? ( mail-filter/bogofilter )
	calendar? (
		>=dev-libs/libical-2.0.0
		>=net-misc/curl-7.9.7
	)
	dbus? ( >=dev-libs/dbus-glib-0.60 )
	gdata? ( >=dev-libs/libgdata-0.17.2 )
	gnutls? ( >=net-libs/gnutls-3.0 )
	gtk3? ( x11-libs/gtk+:3 )
	!gtk3? ( >=x11-libs/gtk+-2.24:2 )
	imap? ( >=net-libs/libetpan-0.57 )
	ldap? ( >=net-nds/openldap-2.0.7 )
	nls? ( >=sys-devel/gettext-0.18 )
	nntp? ( >=net-libs/libetpan-0.57 )
	notification? (
		dev-libs/glib:2
		libcanberra? (  media-libs/libcanberra[gtk] )
		libindicate? ( dev-libs/libindicate:3[gtk] )
		libnotify? ( x11-libs/libnotify )
	)
	pda? ( >=app-pda/jpilot-0.99 )
	pdf? ( app-text/poppler[cairo] )
	pgp? ( >=app-crypt/gpgme-1.0.0 )
	session? (
		x11-libs/libICE
		x11-libs/libSM
	)
	smime? ( >=app-crypt/gpgme-1.0.0 )
	spam-report? ( >=net-misc/curl-7.9.7 )
	spell? ( >=app-text/enchant-1.0.0 )
	startup-notification? ( x11-libs/startup-notification )
	svg? ( >=gnome-base/librsvg-2.40.5 )
	valgrind? ( dev-util/valgrind )
"

DEPEND="${COMMONDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig
	xface? ( >=media-libs/compface-1.4 )"

RDEPEND="${COMMONDEPEND}
	app-misc/mime-types
	x11-misc/shared-mime-info
	clamav? ( app-antivirus/clamav )
	networkmanager? ( net-misc/networkmanager )
	pdf? ( app-text/ghostscript-gpl )
	perl? ( dev-lang/perl:= )
	python? (
		${PYTHON_DEPS}
		>=dev-python/pygtk-2.10.3
	)
	rss? (
		dev-libs/libxml2
		net-misc/curl
	)"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# Don't use libsoup-gnome (bug #565924)
	export HAVE_LIBSOUP_GNOME=no

	local myeconfargs=(
		--disable-bsfilter-plugin
		--disable-fancy-plugin
		--disable-generic-umpc
		--enable-acpi_notifier-plugin
		--enable-address_keeper-plugin
		--enable-alternate-addressbook
		--enable-att_remover-plugin
		--enable-attachwarner-plugin
		--enable-fetchinfo-plugin
		--enable-mailmbox-plugin
		--enable-newmail-plugin
		--enable-tnef_parse-plugin
		--with-password-encryption=$(usex gnutls gnutls old)
		$(use_enable archive archive-plugin)
		$(use_enable bogofilter bogofilter-plugin)
		$(use_enable calendar vcalendar-plugin)
		$(use_enable clamav clamd-plugin)
		$(use_enable dbus)
		$(use_enable debug crash-dialog)
		$(use_enable doc manual)
		$(use_enable gdata gdata-plugin)
		$(use_enable gnutls)
		$(use_enable gtk3)
		$(use_enable ipv6)
		$(use_enable ldap)
		$(use_enable networkmanager)
		$(use_enable nls)
		$(use_enable notification notification-plugin)
		$(use_enable pda jpilot)
		$(use_enable pdf pdf_viewer-plugin)
		$(use_enable perl perl-plugin)
		$(use_enable pgp pgpcore-plugin)
		$(use_enable pgp pgpinline-plugin)
		$(use_enable pgp pgpmime-plugin)
		$(use_enable python python-plugin)
		$(use_enable rss rssyl-plugin)
		$(use_enable session libsm)
		$(use_enable sieve managesieve-plugin)
		$(use_enable smime smime-plugin)
		$(use_enable spam-report spam_report-plugin)
		$(use_enable spamassassin spamassassin-plugin)
		$(use_enable spell enchant)
		$(use_enable startup-notification)
		$(use_enable svg)
		$(use_enable valgrind valgrind)
		$(use_enable xface compface)
	)

	# libetpan is needed if user wants nntp or imap functionality
	if use imap || use nntp ; then
		myeconfargs+=( --enable-libetpan )
	else
		myeconfargs+=( --disable-libetpan )
	fi

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

src_install() {
	local DOCS=( AUTHORS ChangeLog* INSTALL* NEWS README* TODO* )
	default

	# Makefile install claws-mail.png in /usr/share/icons/hicolor/48x48/apps
	# => also install it in /usr/share/pixmaps for other desktop envs
	# => also install higher resolution icons in /usr/share/icons/hicolor/...
	insinto /usr/share/pixmaps
	doins ${PN}.png
	local size
	for size in 64 128 ; do
		newicon -s ${size} ${PN}-${size}x${size}.png ${PN}.png
	done

	docinto tools
	dodoc tools/README*

	domenu ${PN}.desktop

	einfo "Installing extra tools"
	cd "${S}"/tools || die
	exeinto /usr/$(get_libdir)/${PN}/tools
	doexe *.pl *.py *.conf *.sh
	doexe tb2claws-mail update-po uudec uuooffice

	# kill useless files
	rm -f "${ED%/}"/usr/lib*/claws-mail/plugins/*.{a,la}
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	ewarn "When upgrading from version 3.9.0 or below some changes have happened:"
	ewarn "- There are no individual plugins in mail-client/claws-mail-* anymore, but they are integrated mostly controlled through USE flags"
	ewarn "- Plugins with no special dependencies are just built and can be loaded through the interface"
	ewarn "- The gtkhtml2, dillo and trayicon plugins have been dropped entirely"
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
