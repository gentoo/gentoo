# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
#
# @ECLASS: mozconfig-v6.45.eclass
# @MAINTAINER:
# mozilla team <mozilla@gentoo.org>
# @SUPPORTED_EAPIS: 5 6 7
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
# This eclass inherits mozconfig helper functions as defined in mozcoreconf-v4,
# and so ebuilds inheriting this eclass do not need to inherit that.

case ${EAPI} in
	0|1|2|3|4)
		die "EAPI=${EAPI} not supported"
		;;
	5)
		inherit multilib
		;;
esac

inherit flag-o-matic toolchain-funcs mozcoreconf-v4

# @ECLASS-VARIABLE: MOZCONFIG_OPTIONAL_WIFI
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set this variable before the inherit line, when an ebuild needs to provide
# optional necko-wifi support via IUSE="wifi".  Currently this would include
# ebuilds for firefox, and potentially seamonkey.
#
# Leave the variable UNSET if necko-wifi support should not be available.
# Set the variable to "enabled" if the use flag should be enabled by default.
# Set the variable to any value if the use flag should exist but not be default-enabled.

# @ECLASS-VARIABLE: MOZCONFIG_OPTIONAL_JIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set this variable before the inherit line, when an ebuild needs to provide
# optional necko-wifi support via IUSE="jit".  Currently this would include
# ebuilds for firefox, and potentially seamonkey.
#
# Leave the variable UNSET if optional jit support should not be available.
# Set the variable to "enabled" if the use flag should be enabled by default.
# Set the variable to any value if the use flag should exist but not be default-enabled.

# @ECLASS-VARIABLE: MOZCONFIG_OPTIONAL_GTK3
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set this variable before the inherit line, when an ebuild can provide
# optional gtk3 support via IUSE="gtk3".  Currently this would include
# ebuilds for firefox, but thunderbird and seamonkey could follow in the future.
#
# Leave the variable UNSET if gtk3 support should not be available.
# Set the variable to "enabled" if the use flag should be enabled by default.
# Set the variable to any value if the use flag should exist but not be default-enabled.

# @ECLASS-VARIABLE: MOZCONFIG_OPTIONAL_QT5
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set this variable before the inherit line, when an ebuild can provide
# optional qt5 support via IUSE="qt5".  Currently this would include
# ebuilds for firefox, but thunderbird and seamonkey could follow in the future.
#
# Leave the variable UNSET if qt5 support should not be available.
# Set the variable to "enabled" if the use flag should be enabled by default.
# Set the variable to any value if the use flag should exist but not be default-enabled.

# use-flags common among all mozilla ebuilds
IUSE="${IUSE} dbus debug ffmpeg +gstreamer +jemalloc3 neon pulseaudio selinux startup-notification system-cairo
	system-harfbuzz system-icu system-jpeg system-libevent system-sqlite system-libvpx"

# some notes on deps:
# gtk:2 minimum is technically 2.10 but gio support (enabled by default) needs 2.14
# media-libs/mesa needs to be 10.2 or above due to a bug with flash+vdpau
# media-libs/libcanberra is dlopen'ed rather than linked

RDEPEND=">=app-text/hunspell-1.2:=
	dev-libs/atk
	dev-libs/expat
	>=x11-libs/cairo-1.10[X]
	>=x11-libs/gtk+-2.18:2
	x11-libs/gdk-pixbuf
	>=x11-libs/pango-1.22.0
	>=media-libs/libpng-1.6.19:0=[apng]
	>=media-libs/mesa-10.2:*
	media-libs/fontconfig
	>=media-libs/freetype-2.4.10
	media-libs/libcanberra:*[pulseaudio?]
	kernel_linux? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )
	virtual/freedesktop-icon-theme
	dbus? ( >=sys-apps/dbus-0.60
		>=dev-libs/dbus-glib-0.72 )
	startup-notification? ( >=x11-libs/startup-notification-0.8 )
	>=dev-libs/glib-2.26:2
	>=sys-libs/zlib-1.2.3
	>=virtual/libffi-3.0.10
	ffmpeg? ( virtual/ffmpeg )
	gstreamer? (
		>=media-libs/gstreamer-1.4.5:1.0
		>=media-libs/gst-plugins-base-1.4.5:1.0
		>=media-libs/gst-plugins-good-1.4.5:1.0
		>=media-plugins/gst-plugins-libav-1.4.5:1.0
	)
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrender
	x11-libs/libXt
	system-cairo? ( >=x11-libs/cairo-1.12[X,xcb] >=x11-libs/pixman-0.19.2 )
	system-icu? ( >=dev-libs/icu-51.1:= )
	system-jpeg? ( >=media-libs/libjpeg-turbo-1.2.1 )
	system-libevent? ( >=dev-libs/libevent-2.0:0= )
	system-sqlite? ( >=dev-db/sqlite-3.9.1:3[secure-delete,debug=] )
	system-harfbuzz? ( >=media-libs/harfbuzz-1.1.3:0=[graphite,icu] >=media-gfx/graphite2-1.3.8 )
"

if [[ ${PV/45.0*/} == "" ]]; then
	RDEPEND+="
	system-libvpx? ( >=media-libs/libvpx-1.3.0:0=[postproc] )"
else
	# 45.1.0 and above bumped the libvpx requirement
	RDEPEND+="
	system-libvpx? ( >=media-libs/libvpx-1.5.0:0=[postproc] )"
fi

if [[ -n ${MOZCONFIG_OPTIONAL_GTK3} ]]; then
	if [[ ${MOZCONFIG_OPTIONAL_GTK3} = "enabled" ]]; then
		IUSE+=" +gtk3"
	else
		IUSE+=" gtk3"
	fi
	RDEPEND+="
	gtk3? ( >=x11-libs/gtk+-3.4.0:3 )"
fi
if [[ -n ${MOZCONFIG_OPTIONAL_QT5} ]]; then
	inherit qmake-utils
	if [[ ${MOZCONFIG_OPTIONAL_QT5} = "enabled" ]]; then
		IUSE+=" +qt5"
	else
		IUSE+=" qt5"
	fi
	RDEPEND+="
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtprintsupport:5
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
		dev-qt/qtdeclarative:5
	)"
fi
if [[ -n ${MOZCONFIG_OPTIONAL_WIFI} ]]; then
	if [[ ${MOZCONFIG_OPTIONAL_WIFI} = "enabled" ]]; then
		IUSE+=" +wifi"
	else
		IUSE+=" wifi"
	fi
	RDEPEND+="
	wifi? (
		kernel_linux? ( >=sys-apps/dbus-0.60
			>=dev-libs/dbus-glib-0.72
			net-misc/networkmanager )
	)"
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

# force system-icu if system-harfbuzz is set to avoid any potential ABI issues
REQUIRED_USE="
	system-harfbuzz? ( system-icu )"

# only one of gtk3 or qt5 should be permitted to be selected, since only one will be used.
[[ -n ${MOZCONFIG_OPTIONAL_GTK3} ]] && [[ -n ${MOZCONFIG_OPTIONAL_QT5} ]] && \
	REQUIRED_USE+=" ?? ( gtk3 qt5 )"

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
	# Migrated from mozcoreconf-v3
	mozconfig_annotate 'more disable_update_strip' \
		--disable-pedantic \
		--disable-installer \
		--disable-strip-libs

	if [[ ${PN} != seamonkey ]]; then
		mozconfig_annotate 'basic_profile' \
			--disable-profilelocking \
			--enable-single-profile \
			--disable-profilesharing
	fi

	# Migrated from mozcoreconf-2
	mozconfig_annotate 'system_libs' \
		--with-system-zlib \
		--enable-pango \
		--enable-svg \
		--with-system-bz2

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
		if use kernel_linux && use wifi && ! use dbus; then
			echo "Enabling dbus support due to wifi request"
			mozconfig_annotate 'dbus required by necko-wifi on linux' --enable-dbus
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
	if use system-libevent; then
		mozconfig_annotate '' --with-system-libevent="${EPREFIX}"/usr
	fi
	mozconfig_annotate '' --prefix="${EPREFIX}"/usr
	mozconfig_annotate '' --libdir="${EPREFIX}"/usr/$(get_libdir)
	mozconfig_annotate 'Gentoo default' --enable-system-hunspell
	mozconfig_annotate '' --disable-gnomeui
	mozconfig_annotate '' --enable-gio
	mozconfig_annotate '' --disable-crashreporter
	mozconfig_annotate 'Gentoo default' --with-system-png
	mozconfig_annotate '' --enable-system-ffi
	mozconfig_annotate 'Gentoo default to honor system linker' --disable-gold
	mozconfig_annotate 'Gentoo default' --disable-skia
	mozconfig_annotate '' --disable-gconf
	mozconfig_annotate '' --with-intl-api

	# default toolkit is cairo-gtk2, optional use flags can change this
	local toolkit="cairo-gtk2"
	local toolkit_comment=""
	if [[ -n ${MOZCONFIG_OPTIONAL_GTK3} ]]; then
		if use gtk3; then
			toolkit="cairo-gtk3"
			toolkit_comment="gtk3 use flag"
		fi
	fi
	if [[ -n ${MOZCONFIG_OPTIONAL_QT5} ]]; then
		if use qt5; then
			toolkit="cairo-qt"
			toolkit_comment="qt5 use flag"
			# need to specify these vars because the qt5 versions are not found otherwise,
			# and setting --with-qtdir overrides the pkg-config include dirs
			local i
			for i in qmake moc rcc; do
				echo "export HOST_${i^^}=\"$(qt5_get_bindir)/${i}\"" \
					>> "${S}"/.mozconfig || die
			done
			echo 'unset QTDIR' >> "${S}"/.mozconfig || die
			mozconfig_annotate '+qt5' --disable-gio
		fi
	fi
	mozconfig_annotate "${toolkit_comment}" --enable-default-toolkit=${toolkit}

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

	use ffmpeg || mozconfig_annotate '-ffmpeg' --disable-ffmpeg
	if use gstreamer ; then
		use ffmpeg && einfo "${PN} will not use ffmpeg unless gstreamer:1.0 is not available at runtime"
		mozconfig_annotate '+gstreamer' --enable-gstreamer=1.0
	else
		mozconfig_annotate '' --disable-gstreamer
	fi
	mozconfig_use_enable pulseaudio

	mozconfig_use_enable system-cairo
	mozconfig_use_enable system-sqlite
	mozconfig_use_with system-jpeg
	mozconfig_use_with system-icu
	mozconfig_use_with system-libvpx
	mozconfig_use_with system-harfbuzz
	mozconfig_use_with system-harfbuzz system-graphite2

	# Modifications to better support ARM, bug 553364
	if use neon ; then
		mozconfig_annotate '' --with-fpu=neon
		mozconfig_annotate '' --with-thumb=yes
		mozconfig_annotate '' --with-thumb-interwork=no
	fi
	if [[ ${CHOST} == armv* ]] ; then
		mozconfig_annotate '' --with-float-abi=hard
		mozconfig_annotate '' --enable-skia

		if ! use system-libvpx ; then
			sed -i -e "s|softfp|hard|" \
				"${S}"/media/libvpx/moz.build
		fi
	fi
}

# @FUNCTION: mozconfig_install_prefs
# @DESCRIPTION:
# Set preferences into the prefs.js file specified as a parameter to
# the function.  This sets both some common prefs to all mozilla
# packages, and any prefs that may relate to the use flags administered
# by mozconfig_config().
#
# Call this within src_install() phase, after copying the template
# prefs file (if any) from ${FILESDIR}
#
# Example:
#
# inherit mozconfig-v6.46
#
# src_install() {
# 	cp "${FILESDIR}"/gentoo-default-prefs.js \
#	"${BUILD_OBJ_DIR}/dist/bin/browser/defaults/preferences/all-gentoo.js"  \
#	|| die
#
# 	mozconfig_install_prefs \
#	"${BUILD_OBJ_DIR}/dist/bin/browser/defaults/preferences/all-gentoo.js"
#
#	...
# }

mozconfig_install_prefs() {
	local prefs_file="${1}"

	einfo "Adding prefs from mozconfig to ${prefs_file}"

	# set dictionary path, to use system hunspell
	echo "pref(\"spellchecker.dictionary_path\", \"${EPREFIX}/usr/share/myspell\");" \
		>>"${prefs_file}" || die

	# force the graphite pref if system-harfbuzz is enabled, since the pref cant disable it
	if use system-harfbuzz ; then
		echo "sticky_pref(\"gfx.font_rendering.graphite.enabled\",true);" \
			>>"${prefs_file}" || die
	fi
}
