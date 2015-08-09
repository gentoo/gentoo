# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit autotools-utils multilib gnome2-utils eutils

DESCRIPTION="An email client (and news reader) based on GTK+"
HOMEPAGE="http://www.claws-mail.org/"

SRC_URI="mirror://sourceforge/sylpheed-claws/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="alpha amd64 ~arm hppa ~mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="bogofilter crypt dbus dillo doc +imap ipv6 ldap nntp pda session smime spamassassin spell +ssl startup-notification xface"

COMMONDEPEND=">=x11-libs/gtk+-2.20:2
	pda? ( >=app-pda/jpilot-0.99 )
	ssl? ( >=net-libs/gnutls-2.2.0 )
	ldap? ( >=net-nds/openldap-2.0.7 )
	crypt? ( >=app-crypt/gpgme-0.4.5 )
	dbus? ( >=dev-libs/dbus-glib-0.60 )
	dillo? ( www-client/dillo )
	spell? ( >=app-text/enchant-1.0.0 )
	imap? ( >=net-libs/libetpan-0.57 )
	nntp? ( >=net-libs/libetpan-0.57 )
	startup-notification? ( x11-libs/startup-notification )
	bogofilter? ( mail-filter/bogofilter )
	session? ( x11-libs/libSM
			x11-libs/libICE )
	smime? ( >=app-crypt/gpgme-0.4.5 )"

DEPEND="${COMMONDEPEND}
	xface? ( >=media-libs/compface-1.4 )
	virtual/pkgconfig"

RDEPEND="${COMMONDEPEND}
	app-misc/mime-types
	x11-misc/shared-mime-info"

PLUGIN_NAMES="acpi-notifier address_keeper archive att-remover attachwarner clamd fancy fetchinfo geolocation gdata gtkhtml mailmbox newmail notification perl python rssyl spam_report tnef_parse vcalendar"

src_configure() {
	local myeconfargs=(
		$(use_enable ipv6)
		$(use_enable ldap)
		$(use_enable dbus)
		$(use_enable pda jpilot)
		$(use_enable spell enchant)
		$(use_enable xface compface)
		$(use_enable doc manual)
		$(use_enable startup-notification)
		$(use_enable session libsm)
		$(use_enable crypt pgpmime-plugin)
		$(use_enable crypt pgpinline-plugin)
		$(use_enable crypt pgpcore-plugin)
		$(use_enable dillo dillo-viewer-plugin)
		$(use_enable spamassassin spamassassin-plugin)
		$(use_enable bogofilter bogofilter-plugin)
		$(use_enable smime smime-plugin)
		--enable-trayicon-plugin
		--disable-maemo
	)

	# libetpan is needed if user wants nntp or imap functionality
	if use imap || use nntp; then
		myeconfargs+=( --enable-libetpan )
	else
		myeconfargs+=( --disable-libetpan )
	fi

	if use ssl; then
		myeconfargs+=( --enable-gnutls )
	else
		myeconfargs+=( --disable-gnutls )
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
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update

	UPDATE_PLUGINS=""
	for x in ${PLUGIN_NAMES}; do
		has_version mail-client/${PN}-$x && UPDATE_PLUGINS="${UPDATE_PLUGINS} $x"
	done
	if [ -n "${UPDATE_PLUGINS}" ]; then
		elog
		elog "You have to re-emerge or update the following plugins:"
		elog
		for x in ${UPDATE_PLUGINS}; do
			elog "    mail-client/${PN}-$x"
		done
		elog
	fi
}

pkg_postrm() {
	gnome2_icon_cache_update
}
