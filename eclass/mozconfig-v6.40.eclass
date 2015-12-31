# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
#
# @ECLASS: mozconfig-v6.40.eclass
# @MAINTAINER:
# mozilla team <mozilla@gentoo.org>
# @BLURB: the new mozilla common configuration eclass for FF33 and newer, v6
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

# @ECLASS-VARIABLE: MOZCONFIG_OPTIONAL_GTK3
# @DESCRIPTION:
# Set this variable before the inherit line, when an ebuild can provide
# optional gtk3 support via IUSE="gtk3".  Currently this would include
# ebuilds for firefox, but thunderbird and seamonkey could follow in the future.
#
# Leave the variable UNSET if gtk3 support should not be available.
# Set the variable to "enabled" if the use flag should be enabled by default.
# Set the variable to any value if the use flag should exist but not be default-enabled.

# use-flags common among all mozilla ebuilds
IUSE="${IUSE} dbus debug gstreamer gstreamer-0 +jemalloc3 pulseaudio selinux startup-notification system-cairo system-icu system-jpeg system-sqlite system-libvpx"

# some notes on deps:
# gtk:2 minimum is technically 2.10 but gio support (enabled by default) needs 2.14
# media-libs/mesa needs to be 10.2 or above due to a bug with flash+vdpau

RDEPEND=">=app-text/hunspell-1.2
	dev-libs/atk
	dev-libs/expat
	>=dev-libs/libevent-1.4.7
	>=x11-libs/cairo-1.10[X]
	>=x11-libs/gtk+-2.18:2
	x11-libs/gdk-pixbuf
	>=x11-libs/pango-1.22.0
	>=media-libs/libpng-1.6.17:0=[apng]
	>=media-libs/mesa-10.2:*
	media-libs/fontconfig
	>=media-libs/freetype-2.4.10
	kernel_linux? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )
	virtual/freedesktop-icon-theme
	dbus? ( >=sys-apps/dbus-0.60
		>=dev-libs/dbus-glib-0.72 )
	startup-notification? ( >=x11-libs/startup-notification-0.8 )
	>=dev-libs/glib-2.26:2
	>=sys-libs/zlib-1.2.3
	>=virtual/libffi-3.0.10
	gstreamer? (
		>=media-libs/gstreamer-1.4.5:1.0
		>=media-libs/gst-plugins-base-1.4.5:1.0
		>=media-libs/gst-plugins-good-1.4.5:1.0
		>=media-plugins/gst-plugins-libav-1.4.5:1.0
	)
	gstreamer-0? (
		>=media-libs/gstreamer-0.10.25:0.10
		media-plugins/gst-plugins-meta:0.10[ffmpeg]
	)
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrender
	x11-libs/libXt
	system-cairo? ( >=x11-libs/cairo-1.12[X] >=x11-libs/pixman-0.19.2 )
	system-icu? ( >=dev-libs/icu-51.1:= )
	system-jpeg? ( >=media-libs/libjpeg-turbo-1.2.1 )
	system-sqlite? ( >=dev-db/sqlite-3.8.9:3[secure-delete,debug=] )
	system-libvpx? ( >=media-libs/libvpx-1.3.0:0=[postproc] )
"

if [[ -n ${MOZCONFIG_OPTIONAL_GTK3} ]]; then
	if [[ ${MOZCONFIG_OPTIONAL_GTK3} = "enabled" ]]; then
		IUSE+=" +gtk3"
	else
		IUSE+=" gtk3"
	fi
	RDEPEND+="
	gtk3? ( >=x11-libs/gtk+-3.14.0:3 )"
fi
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

RDEPEND+="
	selinux? ( sec-policy/selinux-mozilla )"

# only one of gstreamer and gstreamer-0 can be enabled at a time, so set REQUIRED_USE to signify this
REQUIRED_USE="?? ( gstreamer gstreamer-0 )"

# @FUNCTION: mozconfig_config
# @DESCRIPTION:
# Set common configure options for mozilla packages.
# Call this within src_configure() phase, after mozconfig_init
#
# Example:
#
# inherit mozconfig-v5.33
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
		--enable-svg \
		--with-system-bz2

	if [[ -n ${MOZCONFIG_OPTIONAL_GTK3} ]]; then
		mozconfig_annotate 'gtk3 use flag' --enable-default-toolkit=$(usex gtk3 cairo-gtk3 cairo-gtk2)
	else
		mozconfig_annotate '' --enable-default-toolkit=cairo-gtk2
	fi

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
	else
		mozconfig_annotate 'enabled by Gentoo' --enable-debug-symbols
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

	# These are forced-on for webm support
	mozconfig_annotate 'required' --enable-ogg
	mozconfig_annotate 'required' --enable-wave

	if [[ -n ${MOZCONFIG_OPTIONAL_JIT} ]]; then
		mozconfig_use_enable jit ion
	fi

	# These are enabled by default in all mozilla applications
	mozconfig_annotate '' --with-system-nspr --with-nspr-prefix="${EPREFIX}"/usr
	mozconfig_annotate '' --with-system-nss --with-nss-prefix="${EPREFIX}"/usr
	mozconfig_annotate '' --x-includes="${EPREFIX}"/usr/include --x-libraries="${EPREFIX}"/usr/$(get_libdir)
	mozconfig_annotate '' --with-system-libevent="${EPREFIX}"/usr
	mozconfig_annotate '' --prefix="${EPREFIX}"/usr
	mozconfig_annotate '' --libdir="${EPREFIX}"/usr/$(get_libdir)
	mozconfig_annotate 'Gentoo default' --enable-system-hunspell
	mozconfig_annotate '' --disable-gnomevfs
	mozconfig_annotate '' --disable-gnomeui
	mozconfig_annotate '' --enable-gio
	mozconfig_annotate '' --disable-crashreporter
	mozconfig_annotate 'Gentoo default' --with-system-png
	mozconfig_annotate '' --enable-system-ffi
	mozconfig_annotate 'Gentoo default to honor system linker' --disable-gold
	mozconfig_annotate '' --disable-gconf

	# Use jemalloc unless libc is not glibc >= 2.4
	# at this time the minimum glibc in the tree is 2.9 so we should be safe.
	if use elibc_glibc && use jemalloc3; then
		# We must force-enable jemalloc 3 via .mozconfig
		echo "export MOZ_JEMALLOC3=1" >> "${S}"/.mozconfig || die
		mozconfig_annotate '' --enable-jemalloc
		mozconfig_annotate '' --enable-replace-malloc
	fi

	mozconfig_annotate '' --target="${CTARGET:-${CHOST}}"
	mozconfig_annotate '' --build="${CTARGET:-${CHOST}}"

	if use gstreamer ; then
		mozconfig_annotate '+gstreamer' --enable-gstreamer=1.0
	elif use gstreamer-0 ; then
		mozconfig_annotate '+gstreamer-0' --enable-gstreamer=0.10
	else
		mozconfig_annotate '' --disable-gstreamer
	fi
	mozconfig_use_enable pulseaudio

	mozconfig_use_enable system-cairo
	mozconfig_use_enable system-sqlite
	mozconfig_use_with system-jpeg
	mozconfig_use_with system-icu
	mozconfig_use_enable system-icu intl-api
	mozconfig_use_with system-libvpx
}
