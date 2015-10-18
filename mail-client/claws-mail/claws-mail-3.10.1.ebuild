# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )
AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils multilib gnome2-utils eutils python-single-r1

DESCRIPTION="An email client (and news reader) based on GTK+"
HOMEPAGE="http://www.claws-mail.org/"

SRC_URI="mirror://sourceforge/${PN}/Claws%20Mail/${PV}/${P}.tar.xz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

IUSE="archive bogofilter calendar clamav dbus debug doc gdata gtk3 +imap ipv6 ldap +libcanberra +libindicate +libnotify networkmanager nntp +notification pda pdf perl +pgp python rss session smime spamassassin spam-report spell +gnutls startup-notification valgrind webkit xface"
REQUIRED_USE="networkmanager? ( dbus )
	smime? ( pgp )
	libcanberra? ( notification )
	libindicate? ( notification )
	libnotify? ( notification )"

# Plugins are all integrated or dropped since 3.9.1
PLUGINBLOCK="!!mail-client/claws-mail-acpi-notifier
	!!mail-client/claws-mail-archive
	!!mail-client/claws-mail-att-remover
	!!mail-client/claws-mail-attachwarner
	!!mail-client/claws-mail-clamd
	!!mail-client/claws-mail-fancy
	!!mail-client/claws-mail-fetchinfo
	!mail-client/claws-mail-gdata
	!!mail-client/claws-mail-geolocation
	!!mail-client/claws-mail-gtkhtml
	!!mail-client/claws-mail-mailmbox
	!!mail-client/claws-mail-newmail
	!!mail-client/claws-mail-notification
	!!mail-client/claws-mail-perl
	!!mail-client/claws-mail-python
	!!mail-client/claws-mail-rssyl
	!!mail-client/claws-mail-spam-report
	!!mail-client/claws-mail-tnef-parse
	!!mail-client/claws-mail-vcalendar
	!!mail-client/claws-mail-address_keeper
	!!mail-client/claws-mail-pdf-viewer"

COMMONDEPEND=">=sys-devel/gettext-0.12.1
	gdata? ( >=dev-libs/libgdata-0.6.4 )
	gtk3? ( x11-libs/gtk+:3 )
	!gtk3? ( >=x11-libs/gtk+-2.20:2 )
	pda? ( >=app-pda/jpilot-0.99 )
	gnutls? ( >=net-libs/gnutls-2.2.0 )
	ldap? ( >=net-nds/openldap-2.0.7 )
	pgp? ( >=app-crypt/gpgme-0.4.5 )
	valgrind? ( dev-util/valgrind )
	dbus? ( >=dev-libs/dbus-glib-0.60 )
	spell? ( >=app-text/enchant-1.0.0 )
	imap? ( >=net-libs/libetpan-0.57 )
	nntp? ( >=net-libs/libetpan-0.57 )
	startup-notification? ( x11-libs/startup-notification )
	session? ( x11-libs/libSM
			x11-libs/libICE )
	archive? ( app-arch/libarchive
		>=net-misc/curl-7.9.7 )
	bogofilter? ( mail-filter/bogofilter )
	notification? (
		libnotify? ( x11-libs/libnotify )
		libcanberra? (  media-libs/libcanberra[gtk] )
		libindicate? ( dev-libs/libindicate:3[gtk] )
		dev-libs/glib
	)
	smime? ( >=app-crypt/gpgme-0.4.5 )
	calendar? ( >=net-misc/curl-7.9.7 )
	pdf? ( app-text/poppler[cairo] )
	spam-report? ( >=net-misc/curl-7.9.7 )
	webkit? ( >=net-libs/webkit-gtk-1.0:2
		>=net-libs/libsoup-gnome-2.26:2.4 )
"

DEPEND="${PLUGINBLOCK}
	${COMMONDEPEND}
	app-arch/xz-utils
	xface? ( >=media-libs/compface-1.4 )
	virtual/pkgconfig"

RDEPEND="${COMMONDEPEND}
	pdf? ( app-text/ghostscript-gpl )
	clamav? ( app-antivirus/clamav )
	networkmanager? ( net-misc/networkmanager )
	perl? ( dev-lang/perl )
	python? ( ${PYTHON_DEPS}
		>=dev-python/pygtk-2.10.3 )
	rss? ( net-misc/curl
		dev-libs/libxml2 )
	app-misc/mime-types
	x11-misc/shared-mime-info"

src_configure() {
	local myeconfargs=(
		$(use_enable debug crash-dialog)
		$(use_enable valgrind valgrind)
		$(use_enable doc manual)
		$(use_enable gtk3)
		$(use_enable ipv6)
		$(use_enable ldap)
		$(use_enable dbus dbus)
		$(use_enable networkmanager)
		$(use_enable pda jpilot)
		$(use_enable session libsm)
		$(use_enable spell enchant)
		$(use_enable gnutls)
		$(use_enable startup-notification)
		$(use_enable xface compface)
		$(use_enable archive archive-plugin)
		$(use_enable bogofilter bogofilter-plugin)
		$(use_enable calendar vcalendar-plugin)
		$(use_enable clamav clamd-plugin)
		$(use_enable gdata gdata-plugin)
		$(use_enable notification notification-plugin)
		$(use_enable pdf pdf_viewer-plugin)
		$(use_enable perl perl-plugin)
		$(use_enable pgp pgpmime-plugin)
		$(use_enable pgp pgpinline-plugin)
		$(use_enable pgp pgpcore-plugin)
		$(use_enable python python-plugin)
		$(use_enable rss rssyl-plugin)
		$(use_enable spamassassin spamassassin-plugin)
		$(use_enable smime smime-plugin)
		$(use_enable spam-report spam_report-plugin)
		$(use_enable webkit fancy-plugin)
		--enable-new-addrbook
		--enable-nls
		--enable-acpi_notifier-plugin
		--enable-address_keeper-plugin
		--enable-att_remover-plugin
		--enable-attachwarner-plugin
		--enable-fetchinfo-plugin
		--enable-mailmbox-plugin
		--enable-newmail-plugin
		--enable-tnef_parse-plugin
		--disable-generic-umpc
		--disable-bsfilter-plugin
		--disable-geolocation-plugin
	)

	# libetpan is needed if user wants nntp or imap functionality
	if use imap || use nntp; then
		myeconfargs+=( --enable-libetpan )
	else
		myeconfargs+=( --disable-libetpan )
	fi

	autotools-utils_src_configure
}

src_install() {
	local DOCS=( AUTHORS ChangeLog* INSTALL* NEWS README* TODO* )
	autotools-utils_src_install

	# Makefile install claws-mail.png in /usr/share/icons/hicolor/48x48/apps
	# => also install it in /usr/share/pixmaps for other desktop envs
	# => also install higher resolution icons in /usr/share/icons/hicolor/...
	insinto /usr/share/pixmaps
	doins ${PN}.png || die
	local res resdir
	for res in 64x64 128x128 ; do
		resdir="/usr/share/icons/hicolor/${res}/apps"
		insinto ${resdir}
		newins ${PN}-${res}.png ${PN}.png || die
	done

	docinto tools
	dodoc tools/README*

	domenu ${PN}.desktop

	einfo "Installing extra tools"
	cd "${S}"/tools
	exeinto /usr/$(get_libdir)/${PN}/tools
	doexe *.pl *.py *.conf *.sh || die
	doexe tb2claws-mail update-po uudec uuooffice || die

	# kill useless files
	rm -f "${D}"/usr/lib*/claws-mail/plugins/*.{a,la}
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
}

pkg_postrm() {
	gnome2_icon_cache_update
}
