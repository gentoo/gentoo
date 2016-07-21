# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_3 python3_4 )
inherit eutils fdo-mime gnome2-utils mono-env multilib python-single-r1

DESCRIPTION="Graphical IRC client based on XChat"
HOMEPAGE="http://hexchat.github.io/"
SRC_URI="https://dl.hexchat.net/hexchat/${P}.tar.xz"

LICENSE="GPL-2 plugin-fishlim? ( MIT )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~amd64-linux"
IUSE="dbus +gtk ipv6 libcanberra libnotify libproxy nls ntlm perl +plugins plugin-checksum plugin-doat plugin-fishlim plugin-sysinfo python spell ssl theme-manager"
REQUIRED_USE="plugins? ( python? ( ${PYTHON_REQUIRED_USE} ) )"

DEPEND="dev-libs/glib:2
	dbus? ( >=dev-libs/dbus-glib-0.98 )
	gtk? ( x11-libs/gtk+:2 )
	libcanberra? ( media-libs/libcanberra )
	libproxy? ( net-libs/libproxy )
	libnotify? ( x11-libs/libnotify )
	nls? ( virtual/libintl )
	ntlm? ( net-libs/libntlm )
	plugins? (
		perl? ( >=dev-lang/perl-5.8.0 )
		plugin-sysinfo? ( sys-apps/pciutils )
		python? ( ${PYTHON_DEPS} )
	)
	spell? ( app-text/iso-codes )
	ssl? ( dev-libs/openssl:0 )
	theme-manager? ( dev-lang/mono )"
RDEPEND="${DEPEND}
	spell? ( app-text/enchant )"
DEPEND="${DEPEND}
	app-arch/xz-utils
	virtual/pkgconfig
	nls? ( dev-util/intltool )
	theme-manager? ( dev-util/monodevelop )"

pkg_setup() {
	use plugins && use python && python-single-r1_pkg_setup
	if use theme-manager ; then
		mono-env_pkg_setup
		export XDG_CACHE_HOME="${T}/.cache"
	fi

	if use !plugins ; then
		local myplugins

		use perl && myplugins+="perl\n"
		use python && myplugins+="python\n"
		use plugin-checksum && myplugins+="plugin-checksum\n"
		use plugin-doat && myplugins+="plugin-doat\n"
		use plugin-fishlim && myplugins+="plugin-fishlim\n"
		use plugin-sysinfo && myplugins+="plugin-sysinfo\n"

		if [[ ${myplugins} ]] ; then
			ewarn "The following plugins/interfaces have been disabled, because"
			ewarn "\"plugins\" USE flag is disabled. Check metadata.xml"
			ewarn "to get more information or run \"equery u hexchat\"."
			ewarn "\n${myplugins}"
		fi
	fi
}

src_prepare() {
	epatch_user
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable libproxy socks) \
		$(use_enable ipv6) \
		$(use_enable ssl openssl) \
		$(use_enable gtk gtkfe) \
		$(use_enable !gtk textfe) \
		$(usex plugins \
			"$(usex python "--enable-python=${EPYTHON}" "--disable-python")" \
			"--disable-python" \
			) \
		$(usex plugins \
			"$(use_enable perl)" \
			"--disable-perl" \
			) \
		$(use_enable plugins plugin) \
		$(usex plugins \
			"$(use_enable plugin-checksum checksum)" \
			"--disable-checksum" \
			) \
		$(usex plugins \
			"$(use_enable plugin-doat doat)" \
			"--disable-doat" \
			) \
		$(usex plugins \
			"$(use_enable plugin-fishlim fishlim)" \
			"--disable-fishlim" \
			) \
		$(usex plugins \
			"$(use_enable plugin-sysinfo sysinfo)" \
			"--disable-sysinfo" \
			) \
		$(use_enable dbus) \
		$(use_enable libnotify) \
		$(use_enable libcanberra) \
		$(use_enable ntlm) \
		$(use_enable libproxy) \
		$(use_enable spell isocodes) \
		--enable-minimal-flags \
		$(use_with theme-manager)
}

src_install() {
	emake DESTDIR="${D}" \
		UPDATE_ICON_CACHE=true \
		UPDATE_MIME_DATABASE=true \
		UPDATE_DESKTOP_DATABASE=true \
		install
	dodoc readme.md
	prune_libtool_files --all
}

pkg_preinst() {
	if use gtk ; then
		gnome2_icon_savelist
	fi
}

pkg_postinst() {
	if use gtk ; then
		gnome2_icon_cache_update
		einfo
	else
		einfo
		elog "You have disabled the gtk USE flag. This means you don't have"
		elog "the GTK-GUI for HexChat but only a text interface called \"hexchat-text\"."
		elog
	fi

	if use theme-manager ; then
		fdo-mime_desktop_database_update
		fdo-mime_mime_database_update
		elog "Themes are available at:"
		elog "  http://hexchat.org/themes.html"
		elog
	fi

	einfo
	elog "optional dependencies:"
	elog "  media-sound/sox (sound playback if you don't have libcanberra"
	elog "    enabled)"
	elog "  x11-plugins/hexchat-javascript (javascript support)"
	elog "  x11-themes/sound-theme-freedesktop (default BEEP sound,"
	elog "    needs libcanberra enabled)"
	einfo
}

pkg_postrm() {
	if use gtk ; then
		gnome2_icon_cache_update
	fi

	if use theme-manager ; then
		fdo-mime_desktop_database_update
		fdo-mime_mime_database_update
	fi
}
