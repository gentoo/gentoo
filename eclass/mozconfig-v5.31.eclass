# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
#
# @ECLASS: mozconfig-v5.31.eclass
# @MAINTAINER:
# mozilla team <mozilla@gentoo.org>
# @BLURB: the new mozilla common configuration eclass for FF31 and newer, v5
# @DESCRIPTION:
# This eclass is used in mozilla ebuilds (firefox, thunderbird, seamonkey)
# to provide a single common place for the common mozilla engine compoments.
#
# The eclass provides all common dependencies as well as common use flags.
#
# Some use flags which may be optional in particular mozilla packages can be
# supported through setting eclass variables.
#
# This eclass inherits mozconfig helper functions as defined in mozcoreconf-v3,
# and so ebuilds inheriting this eclass do not need to inherit that.

inherit multilib flag-o-matic toolchain-funcs mozcoreconf-v3

case ${EAPI} in
	0|1|2|3|4) die "EAPI=${EAPI} not supported"
esac

# @ECLASS-VARIABLE: MOZCONFIG_OPTIONAL_WIFI
# @DESCRIPTION:
# Set this variable before the inherit line, when an ebuild needs to provide
# optional necko-wifi support via IUSE="wifi".  Currently this would include
# ebuilds for firefox, and potentially seamonkey.
#
# Leave the variable UNSET if necko-wifi support should not be available.
# Set the variable to "enabled" if the use flag should be enabled by default.
# Set the variable to any value if the use flag should exist but not be default-enabled.

# @ECLASS-VARIABLE: MOZCONFIG_OPTIONAL_JIT
# @DESCRIPTION:
# Set this variable before the inherit line, when an ebuild needs to provide
# optional necko-wifi support via IUSE="jit".  Currently this would include
# ebuilds for firefox, and potentially seamonkey.
#
# Leave the variable UNSET if optional jit support should not be available.
# Set the variable to "enabled" if the use flag should be enabled by default.
# Set the variable to any value if the use flag should exist but not be default-enabled.

# use-flags common among all mozilla ebuilds
IUSE="${IUSE} dbus debug gstreamer pulseaudio startup-notification system-cairo system-icu system-jpeg system-sqlite system-libvpx"

# some notes on deps:
# gtk:2 minimum is technically 2.10 but gio support (enabled by default) needs 2.14
# media-libs/mesa needs to be 10.2 or above due to a bug with flash+vdpau

RDEPEND=">=app-text/hunspell-1.2
	dev-libs/atk
	dev-libs/expat
	>=dev-libs/libevent-1.4.7
	>=x11-libs/cairo-1.10[X]
	>=x11-libs/gtk+-2.14:2
	x11-libs/gdk-pixbuf
	>=x11-libs/pango-1.22.0
	>=media-libs/libpng-1.6.10:0=[apng]
	>=media-libs/mesa-10.2:*
	media-libs/fontconfig
	>=media-libs/freetype-2.4.10
	kernel_linux? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )
	>=sys-libs/zlib-1.2.3
	virtual/freedesktop-icon-theme
	dbus? ( >=sys-apps/dbus-0.60
		>=dev-libs/dbus-glib-0.72 )
	startup-notification? ( >=x11-libs/startup-notification-0.8 )
	>=dev-libs/glib-2.26:2
	virtual/libffi
	gstreamer? ( media-plugins/gst-plugins-meta:1.0[ffmpeg] )
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libXt
	system-cairo? ( >=x11-libs/cairo-1.12[X] >=x11-libs/pixman-0.19.2 )
	system-icu? ( >=dev-libs/icu-51.1:= )
	system-jpeg? ( >=media-libs/libjpeg-turbo-1.2.1 )
	system-sqlite? ( >=dev-db/sqlite-3.8.4.2:3[secure-delete,debug=] )
"

# firefox-31.0-patches-0.3 and above carry a patch making newer libvpx compatible
case ${PATCHFF##*31.0-patches-} in
	0.3)	RDEPEND+=" system-libvpx? ( >=media-libs/libvpx-1.3.0:0= )" ;;
	*)	RDEPEND+=" system-libvpx? ( =media-libs/libvpx-1.3.0* )" ;;
esac

if [[ -n ${MOZCONFIG_OPTIONAL_WIFI} ]]; then
	if [[ ${MOZCONFIG_OPTIONAL_WIFI} = "enabled" ]]; then
		IUSE+=" +wifi"
	else
		IUSE+=" wifi"
	fi
	RDEPEND+="
	wifi? ( >=sys-apps/dbus-0.60
		>=dev-libs/dbus-glib-0.72
		net-wireless/wireless-tools )"
fi
if [[ -n ${MOZCONFIG_OPTIONAL_JIT} ]]; then
	if [[ ${MOZCONFIG_OPTIONAL_JIT} = "enabled" ]]; then
		IUSE+=" +jit"
	else
		IUSE+=" jit"
	fi
fi

DEPEND="app-arch/zip
	app-arch/unzip
	>=sys-devel/binutils-2.16.1
	${RDEPEND}"

# @FUNCTION: mozconfig_config
# @DESCRIPTION:
# Set common configure options for mozilla packages.
# Call this within src_configure() phase, after mozconfig_init
#
# Example:
#
# inherit mozconfig-v5.31
#
# src_configure() {
# 	mozconfig_init
# 	mozconfig_config
#	# ... misc ebuild-unique settings via calls to
#	# ... mozconfig_{annotate,use_with,use_enable}
#	mozconfig_final
# }

mozconfig_config() {
	# Migrated from mozcoreconf-2
	mozconfig_annotate 'system_libs' \
		--with-system-zlib \
		--enable-pango \
		--enable-svg

	mozconfig_annotate '' --enable-default-toolkit=cairo-gtk2

	if has bindist ${IUSE}; then
		mozconfig_use_enable !bindist official-branding
		if [[ ${PN} == firefox ]] && use bindist ; then
			mozconfig_annotate '' --with-branding=browser/branding/aurora
		fi
	fi

	mozconfig_use_enable debug
	mozconfig_use_enable debug tests

	if ! use debug ; then
		mozconfig_annotate 'disabled by Gentoo' --disable-debug-symbols
	fi

	mozconfig_use_enable startup-notification

	if [[ -n ${MOZCONFIG_OPTIONAL_WIFI} ]] ; then
		# wifi pulls in dbus so manage both here
		mozconfig_use_enable wifi necko-wifi
		if use wifi && ! use dbus; then
			echo "Enabling dbus support due to wifi request"
			mozconfig_annotate 'dbus required by necko-wifi' --enable-dbus
		else
			mozconfig_use_enable dbus
		fi
	else
		mozconfig_use_enable dbus
		mozconfig_annotate 'disabled' --disable-necko-wifi
	fi

	mozconfig_annotate 'required' --enable-ogg
	mozconfig_annotate 'required' --enable-wave

	if [[ -n ${MOZCONFIG_OPTIONAL_JIT} ]]; then
		mozconfig_use_enable jit ion
		mozconfig_use_enable jit yarr-jit
	fi

	# These are enabled by default in all mozilla applications
	mozconfig_annotate '' --with-system-nspr --with-nspr-prefix="${EPREFIX}"/usr
	mozconfig_annotate '' --with-system-nss --with-nss-prefix="${EPREFIX}"/usr
	mozconfig_annotate '' --x-includes="${EPREFIX}"/usr/include --x-libraries="${EPREFIX}"/usr/$(get_libdir)
	mozconfig_annotate '' --with-system-libevent="${EPREFIX}"/usr
	mozconfig_annotate '' --prefix="${EPREFIX}"/usr
	mozconfig_annotate '' --libdir="${EPREFIX}"/usr/$(get_libdir)
	mozconfig_annotate '' --enable-system-hunspell
	mozconfig_annotate '' --disable-gnomevfs
	mozconfig_annotate '' --disable-gnomeui
	mozconfig_annotate '' --enable-gio
	mozconfig_annotate '' --disable-crashreporter
	mozconfig_annotate '' --with-system-png
	mozconfig_annotate '' --enable-system-ffi
	mozconfig_annotate '' --disable-gold
	mozconfig_annotate '' --disable-gconf

	# We must force enable jemalloc 3 threw .mozconfig
	echo "export MOZ_JEMALLOC=1" >> "${S}"/.mozconfig || die
	mozconfig_annotate '' --enable-jemalloc
	mozconfig_annotate '' --enable-replace-malloc

	mozconfig_annotate '' --target="${CTARGET:-${CHOST}}"
	mozconfig_annotate '' --build="${CTARGET:-${CHOST}}"

	if use gstreamer; then
		mozconfig_annotate '+gstreamer' --enable-gstreamer=1.0
	else
		mozconfig_annotate '' --disable-gstreamer
	fi
	mozconfig_use_enable pulseaudio

	mozconfig_use_enable system-cairo
	mozconfig_use_enable system-sqlite
	mozconfig_use_with system-jpeg
	mozconfig_use_with system-icu
	mozconfig_use_with system-icu intl-api
	mozconfig_use_with system-libvpx
}
