# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/pulseaudio/pulseaudio-5.0-r4.ebuild,v 1.5 2015/03/17 14:19:01 tetromino Exp $

EAPI="5"
inherit autotools bash-completion-r1 eutils flag-o-matic linux-info readme.gentoo systemd user versionator udev multilib-minimal

DESCRIPTION="A networked sound server with an advanced plugin system"
HOMEPAGE="http://www.pulseaudio.org/"
SRC_URI="http://freedesktop.org/software/pulseaudio/releases/${P}.tar.xz"

# libpulse-simple and libpulse link to libpulse-core; this is daemon's
# library and can link to gdbm and other GPL-only libraries. In this
# cases, we have a fully GPL-2 package. Leaving the rest of the
# GPL-forcing USE flags for those who use them.
LICENSE="!gdbm? ( LGPL-2.1 ) gdbm? ( GPL-2 )"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~sh sparc x86 ~amd64-linux ~x86-linux"

IUSE="+alsa +asyncns avahi bluetooth +caps dbus doc equalizer +gdbm +glib gnome
gtk ipv6 jack libsamplerate lirc neon +orc oss qt4 realtime ssl systemd
system-wide tcpd test +udev +webrtc-aec +X xen"

# See "*** BLUEZ support not found (requires D-Bus)" in configure.ac
REQUIRED_USE="bluetooth? ( dbus )
	udev? ( || ( alsa oss ) )"

# libpcre needed in some cases, bug #472228
RDEPEND="
	|| (
		elibc_glibc? ( virtual/libc )
		elibc_uclibc? ( virtual/libc )
		dev-libs/libpcre
	)
	>=media-libs/libsndfile-1.0.20[${MULTILIB_USEDEP}]
	X? (
		>=x11-libs/libX11-1.4.0[${MULTILIB_USEDEP}]
		>=x11-libs/libxcb-1.6[${MULTILIB_USEDEP}]
		x11-libs/libSM[${MULTILIB_USEDEP}]
		x11-libs/libICE[${MULTILIB_USEDEP}]
		x11-libs/libXtst[${MULTILIB_USEDEP}]
	)
	caps? ( sys-libs/libcap[${MULTILIB_USEDEP}] )
	libsamplerate? ( >=media-libs/libsamplerate-0.1.1-r1 )
	alsa? ( >=media-libs/alsa-lib-1.0.19 )
	glib? ( >=dev-libs/glib-2.4.0[${MULTILIB_USEDEP}] )
	avahi? ( >=net-dns/avahi-0.6.12[dbus] )
	jack? ( >=media-sound/jack-audio-connection-kit-0.117 )
	tcpd? ( sys-apps/tcp-wrappers[${MULTILIB_USEDEP}] )
	lirc? ( app-misc/lirc )
	dbus? ( >=sys-apps/dbus-1.0.0[${MULTILIB_USEDEP}] )
	gtk? ( x11-libs/gtk+:3 )
	gnome? ( >=gnome-base/gconf-2.4.0 )
	bluetooth? (
		net-wireless/bluez:=
		>=sys-apps/dbus-1.0.0
		media-libs/sbc
	)
	asyncns? ( net-libs/libasyncns[${MULTILIB_USEDEP}] )
	udev? ( >=virtual/udev-143[hwdb(+)] )
	realtime? ( sys-auth/rtkit )
	equalizer? ( sci-libs/fftw:3.0 )
	orc? ( >=dev-lang/orc-0.4.15 )
	ssl? ( dev-libs/openssl:0 )
	>=media-libs/speex-1.2_rc1
	gdbm? ( sys-libs/gdbm )
	webrtc-aec? ( media-libs/webrtc-audio-processing )
	xen? ( app-emulation/xen-tools )
	systemd? ( sys-apps/systemd:0=[${MULTILIB_USEDEP}] )
	dev-libs/json-c[${MULTILIB_USEDEP}]
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-soundlibs-20131008-r1
		!app-emulation/emul-linux-x86-soundlibs[-abi_x86_32(-)] )
	|| (
		dev-libs/libltdl:0
		( >=sys-devel/libtool-2.4.2 <sys-devel/libtool-2.4.3-r2 )
	)
"
# it's a valid RDEPEND, libltdl.so is used for native abi

DEPEND="${RDEPEND}
	sys-devel/m4
	doc? ( app-doc/doxygen )
	test? ( dev-libs/check )
	X? (
		x11-proto/xproto[${MULTILIB_USEDEP}]
		>=x11-libs/libXtst-1.0.99.2[${MULTILIB_USEDEP}]
	)
	dev-libs/libatomic_ops
	virtual/pkgconfig
	system-wide? ( || ( dev-util/unifdef sys-freebsd/freebsd-ubin ) )
	dev-util/intltool
	>=sys-devel/gettext-0.18.1
"
# This is a PDEPEND to avoid a circular dep
PDEPEND="alsa? ( >=media-plugins/alsa-plugins-1.0.27-r1[pulseaudio] )"

# alsa-utils dep is for the alsasound init.d script (see bug #155707)
# bluez dep is for the bluetooth init.d script
# PyQt4 dep is for the qpaeq script
RDEPEND="${RDEPEND}
	equalizer? ( qt4? ( dev-python/PyQt4[dbus] ) )
	system-wide? (
		alsa? ( media-sound/alsa-utils )
		bluetooth? ( net-wireless/bluez:= )
	)
"

pkg_pretend() {
	CONFIG_CHECK="~HIGH_RES_TIMERS"
	WARNING_HIGH_RES_TIMERS="CONFIG_HIGH_RES_TIMERS:\tis not set (required for enabling timer-based scheduling in pulseaudio)\n"
	check_extra_config

	if linux_config_exists; then
		local snd_hda_prealloc_size=$(linux_chkconfig_string SND_HDA_PREALLOC_SIZE)
		if [ -n "${snd_hda_prealloc_size}" ] && [ "${snd_hda_prealloc_size}" -lt 2048 ]; then
			ewarn "A preallocated buffer-size of 2048 (kB) or higher is recommended for the HD-audio driver!"
			ewarn "CONFIG_SND_HDA_PREALLOC_SIZE=${snd_hda_prealloc_size}"
		fi
	fi
}

pkg_setup() {
	linux-info_pkg_setup

	enewgroup audio 18 # Just make sure it exists

	if use system-wide; then
		enewgroup pulse-access
		enewgroup pulse
		enewuser pulse -1 -1 /var/run/pulse pulse,audio
	fi
}

src_prepare() {
	# Skip test that cannot work with sandbox, bug #501846
	sed -i -e '/lock-autospawn-test/d' src/Makefile.am || die

	# Fix CVE-2014-3970, bug #512516
	epatch "${FILESDIR}/${P}-crash-udp.patch"

	# module-switch-on-port-available: Don't switch profiles on uninitialized cards (from 'master')
	epatch "${FILESDIR}/${P}-module-switch.patch"

	epatch_user
	eautoreconf
}

multilib_src_configure() {
	local myconf=()

	if use gdbm; then
		myconf+=( --with-database=gdbm )
	#elif use tdb; then
	#	myconf+=( --with-database=tdb )
	else
		myconf+=( --with-database=simple )
	fi

	if use bluetooth; then
		if has_version '<net-wireless/bluez-5'; then
			myconf+=( --disable-bluez5 --enable-bluez4 )
		else
			 myconf+=( --enable-bluez5 --disable-bluez4 )
		fi
	else
		myconf+=( --disable-bluez5 --disable-bluez4 )
	fi

	myconf+=(
		--enable-largefile
		$(use_enable glib glib2)
		--disable-solaris
		$(use_enable asyncns)
		$(use_enable oss oss-output)
		$(use_enable alsa)
		$(use_enable lirc)
		$(use_enable neon neon-opt)
		$(use_enable tcpd tcpwrap)
		$(use_enable jack)
		$(use_enable avahi)
		$(use_enable dbus)
		$(use_enable gnome gconf)
		$(use_enable gtk gtk3)
		$(use_enable libsamplerate samplerate)
		$(use_enable orc)
		$(use_enable X x11)
		$(use_enable test default-build-tests)
		$(use_enable udev)
		$(use_enable systemd)
		$(use_enable systemd systemd-journal)
		$(use_enable ipv6)
		$(use_enable ssl openssl)
		$(use_enable webrtc-aec)
		$(use_enable xen)
		$(use_with caps)
		$(use_with equalizer fftw)
		--disable-adrian-aec
		--disable-esound
		--localstatedir="${EPREFIX}"/var
		--with-udev-rules-dir="${EPREFIX}/$(get_udevdir)"/rules.d
	)

	if ! multilib_is_native_abi; then
		# disable all the modules and stuff
		myconf+=(
			--disable-oss-output
			--disable-alsa
			--disable-lirc
			--disable-jack
			--disable-avahi
			--disable-gconf
			--disable-gtk3
			--disable-samplerate
			--disable-bluez4
			--disable-bluez5
			--disable-udev
			--disable-systemd
			--disable-openssl
			--disable-orc
			--disable-webrtc-aec
			--disable-xen
			--without-fftw

			# tests involve random modules, so just do them for the native
			--disable-default-build-tests

			# hack around unnecessary checks
			# (results don't matter, we're not building anything using it)
			ac_cv_lib_ltdl_lt_dladvise_init=yes
			--with-database=simple
			LIBSPEEX_CFLAGS=' '
			LIBSPEEX_LIBS=' '
		)
	fi

	ECONF_SOURCE=${S} \
	econf "${myconf[@]}"
}

multilib_src_compile() {
	if multilib_is_native_abi; then
		emake
	else
		local targets=( libpulse.la libpulse-simple.la )
		use glib && targets+=( libpulse-mainloop-glib.la )
		emake -C src ${targets[@]}
	fi
}

src_compile() {
	multilib-minimal_src_compile

	if use doc; then
		pushd doxygen
		doxygen doxygen.conf
		popd
	fi
}

multilib_src_test() {
	# We avoid running the toplevel check target because that will run
	# po/'s tests too, and they are broken. Officially, it should work
	# with intltool 0.41, but that doesn't look like a stable release.
	if multilib_is_native_abi; then
		emake -C src check
	fi
}

multilib_src_install() {
	if multilib_is_native_abi; then
		emake -j1 DESTDIR="${D}" bashcompletiondir="$(get_bashcompdir)" install
	else
		local targets=( libpulse.la libpulse-simple.la )
		use glib && targets+=( libpulse-mainloop-glib.la )
		emake DESTDIR="${D}" install-pkgconfigDATA
		emake DESTDIR="${D}" -C src \
			install-libLTLIBRARIES \
			lib_LTLIBRARIES="${targets[*]}" \
			install-pulseincludeHEADERS
	fi
}

multilib_src_install_all() {
	# Drop the script entirely if X is disabled
	use X || rm "${ED}"/usr/bin/start-pulseaudio-x11

	if use system-wide; then
		newconfd "${FILESDIR}/pulseaudio.conf.d" pulseaudio

		use_define() {
			local define=${2:-$(echo $1 | tr '[:lower:]' '[:upper:]')}

			use "$1" && echo "-D$define" || echo "-U$define"
		}

		unifdef $(use_define avahi) \
			$(use_define alsa) \
			$(use_define bluetooth) \
			$(use_define udev) \
			"${FILESDIR}/pulseaudio.init.d-5" \
			> "${T}/pulseaudio"

		doinitd "${T}/pulseaudio"

		systemd_dounit "${FILESDIR}/${PN}.service"
	fi

	use avahi && sed -i -e '/module-zeroconf-publish/s:^#::' "${ED}/etc/pulse/default.pa"

	dodoc NEWS README todo

	if use doc; then
		pushd doxygen/html
		dohtml *
		popd
	fi

	# Create the state directory
	use prefix || diropts -o pulse -g pulse -m0755

	# We need /var/run/pulse, bug #442852
	use system-wide && systemd_newtmpfilesd "${FILESDIR}/${PN}.tmpfiles" "${PN}.conf"

	# Prevent warnings when system-wide is not used, bug #447694
	use system-wide || rm "${ED}"/etc/dbus-1/system.d/pulseaudio-system.conf

	prune_libtool_files --all
}

pkg_postinst() {
	if use system-wide; then
		elog "You have enabled the 'system-wide' USE flag for pulseaudio."
		elog "This mode should only be used on headless servers, embedded systems,"
		elog "or thin clients. It will usually require manual configuration, and is"
		elog "incompatible with many expected pulseaudio features."
		elog "On normal desktop systems, system-wide mode is STRONGLY DISCOURAGED."
		elog "For more information, see"
		elog "    http://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/WhatIsWrongWithSystemWide/"
		elog "    http://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/SystemWide/"
		elog "    https://wiki.gentoo.org/wiki/PulseAudio#Headless_server"
		if use gnome ; then
			elog
			elog "By enabling gnome USE flag, you enabled gconf support. Please note"
			elog "that you might need to remove the gnome USE flag or disable the"
			elog "gconf module on /etc/pulse/system.pa to be able to use PulseAudio"
			elog "with a system-wide instance."
		fi
	fi

	if use equalizer && ! use qt4; then
		elog "You've enabled the 'equalizer' USE-flag but not the 'qt4' USE-flag."
		elog "This will build the equalizer module, but the 'qpaeq' tool"
		elog "which is required to set equalizer levels will not work."
	fi
}
