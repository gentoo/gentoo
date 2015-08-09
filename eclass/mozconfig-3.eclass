# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
#
# mozconfig.eclass: the new mozilla.eclass

inherit multilib flag-o-matic mozcoreconf-2

# use-flags common among all mozilla ebuilds
IUSE="+alsa +dbus debug libnotify startup-notification system-sqlite wifi"

# XXX: GConf is used for setting the default browser
#      revisit to make it optional with GNOME 3
# pango[X] is needed for pangoxft.h
# freedesktop-icon-theme is needed for bug 341697
RDEPEND="app-arch/zip
	app-arch/unzip
	>=app-text/hunspell-1.2
	dev-libs/expat
	>=dev-libs/libevent-1.4.7
	>=x11-libs/cairo-1.8[X]
	>=x11-libs/gtk+-2.8.6:2
	>=x11-libs/pango-1.10.1[X]
	virtual/jpeg:0
	alsa? ( media-libs/alsa-lib )
	virtual/freedesktop-icon-theme
	dbus? ( >=dev-libs/dbus-glib-0.72 )
	libnotify? ( >=x11-libs/libnotify-0.4 )
	startup-notification? ( >=x11-libs/startup-notification-0.8 )
	wifi? ( net-wireless/wireless-tools )"
DEPEND="${RDEPEND}"

mozconfig_config() {
	mozconfig_annotate '' --enable-default-toolkit=cairo-gtk2

	if has bindist ${IUSE}; then
		mozconfig_use_enable !bindist official-branding
		if [[ ${PN} == firefox ]] && use bindist ; then
			mozconfig_annotate '' --with-branding=browser/branding/aurora
		fi
	fi

	if ! $(mozversion_is_new_enough) ; then
		mozconfig_use_enable alsa ogg
		mozconfig_use_enable alsa wave
		mozconfig_use_enable libnotify
		mozconfig_use_enable debug debugger-info-modules
		if has +ipc ${IUSE}; then
			mozconfig_use_enable ipc
		fi
		if [[ ${PN} != thunderbird ]] ; then
			mozconfig_annotate 'places' --enable-storage --enable-places --enable-places_bookmarks
			mozconfig_annotate '' --enable-oji --enable-mathml
			mozconfig_annotate 'broken' --disable-mochitest
		fi
		if use system-sqlite; then
			mozconfig_annotate '' --with-sqlite-prefix="${EPREFIX}"/usr
		fi
		if use amd64 || use x86 || use arm || use sparc; then
			mozconfig_annotate '' --enable-tracejit
		fi
	fi

	mozconfig_use_enable dbus
	mozconfig_use_enable debug
	mozconfig_use_enable debug tests
	if ! use debug ; then
		mozconfig_annotate 'disabled by Gentoo' --disable-debug-symbols
	fi
	mozconfig_use_enable startup-notification
	mozconfig_use_enable system-sqlite
	mozconfig_use_enable wifi necko-wifi

	if $(mozversion_is_new_enough) ; then
		mozconfig_annotate 'required' --enable-ogg
		mozconfig_annotate 'required' --enable-wave
		mozconfig_annotate 'required' --with-system-libvpx
	elif has +webm ${IUSE} && use webm; then
		if ! use alsa; then
			echo "Enabling alsa support due to webm request"
			mozconfig_annotate '+webm -alsa' --enable-ogg
			mozconfig_annotate '+webm -alsa' --enable-wave
			mozconfig_annotate '+webm' --enable-webm
			mozconfig_annotate '+webm' --with-system-libvpx
		else
			mozconfig_use_enable webm
			mozconfig_annotate '+webm' --with-system-libvpx
		fi
	else
		mozconfig_annotate '' --disable-webm
		mozconfig_annotate '' --disable-system-libvpx
	fi

	# These are enabled by default in all mozilla applications
	mozconfig_annotate '' --with-system-nspr --with-nspr-prefix="${EPREFIX}"/usr
	mozconfig_annotate '' --with-system-nss --with-nss-prefix="${EPREFIX}"/usr
	mozconfig_annotate '' --x-includes="${EPREFIX}"/usr/include --x-libraries="${EPREFIX}"/usr/$(get_libdir)
	mozconfig_annotate '' --with-system-libevent="${EPREFIX}"/usr
	mozconfig_annotate '' --enable-system-hunspell
	mozconfig_annotate '' --disable-gnomevfs
	mozconfig_annotate '' --disable-gnomeui
	mozconfig_annotate '' --enable-gio
	mozconfig_annotate '' --disable-crashreporter
}
