# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools bash-completion-r1 flag-o-matic gnome2-utils linux-info systemd toolchain-funcs udev multilib-minimal tmpfiles

DESCRIPTION="A networked sound server with an advanced plugin system"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/PulseAudio/"
SRC_URI="https://freedesktop.org/software/pulseaudio/releases/${P}.tar.xz"

# libpulse-simple and libpulse link to libpulse-core; this is daemon's
# library and can link to gdbm and other GPL-only libraries. In this
# cases, we have a fully GPL-2 package. Leaving the rest of the
# GPL-forcing USE flags for those who use them.
LICENSE="!gdbm? ( LGPL-2.1 ) gdbm? ( GPL-2 )"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"

# +alsa-plugin as discussed in bug #519530
IUSE="+alsa +alsa-plugin +asyncns bluetooth +caps dbus doc equalizer elogind gconf
+gdbm +glib gtk ipv6 jack libsamplerate libressl lirc native-headset cpu_flags_arm_neon
ofono-headset +orc oss qt5 realtime selinux sox ssl systemd system-wide tcpd test
+udev +webrtc-aec +X zeroconf"

RESTRICT="!test? ( test )"
# See "*** BLUEZ support not found (requires D-Bus)" in configure.ac
REQUIRED_USE="
	?? ( elogind systemd )
	bluetooth? ( dbus )
	equalizer? ( dbus )
	ofono-headset? ( bluetooth )
	native-headset? ( bluetooth )
	realtime? ( dbus )
	udev? ( || ( alsa oss ) )
"

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
	caps? ( >=sys-libs/libcap-2.22-r2[${MULTILIB_USEDEP}] )
	libsamplerate? ( >=media-libs/libsamplerate-0.1.1-r1 )
	alsa? ( >=media-libs/alsa-lib-1.0.19 )
	glib? ( >=dev-libs/glib-2.26.0:2[${MULTILIB_USEDEP}] )
	zeroconf? ( >=net-dns/avahi-0.6.12[dbus] )
	jack? ( virtual/jack )
	tcpd? ( sys-apps/tcp-wrappers[${MULTILIB_USEDEP}] )
	lirc? ( app-misc/lirc )
	dbus? ( >=sys-apps/dbus-1.0.0[${MULTILIB_USEDEP}] )
	gtk? ( x11-libs/gtk+:3 )
	bluetooth? (
		>=net-wireless/bluez-5
		>=sys-apps/dbus-1.0.0
		media-libs/sbc
	)
	asyncns? ( net-libs/libasyncns[${MULTILIB_USEDEP}] )
	udev? ( >=virtual/udev-143[hwdb(+)] )
	equalizer? ( sci-libs/fftw:3.0 )
	ofono-headset? ( >=net-misc/ofono-1.13 )
	orc? ( >=dev-lang/orc-0.4.15 )
	sox? ( >=media-libs/soxr-0.1.1 )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:= )
	)
	media-libs/speexdsp
	gdbm? ( sys-libs/gdbm:= )
	webrtc-aec? ( >=media-libs/webrtc-audio-processing-0.2 )
	elogind? ( sys-auth/elogind )
	systemd? ( sys-apps/systemd:0=[${MULTILIB_USEDEP}] )
	dev-libs/libltdl:0
	selinux? ( sec-policy/selinux-pulseaudio )
	realtime? ( sys-auth/rtkit )
	gconf? ( >=gnome-base/gconf-3.2.6 )
" # libltdl is a valid RDEPEND, libltdl.so is used for native abi in pulsecore and daemon

DEPEND="${RDEPEND}
	X? (
		x11-base/xorg-proto
		>=x11-libs/libXtst-1.0.99.2[${MULTILIB_USEDEP}]
	)
	dev-libs/libatomic_ops
"
# This is a PDEPEND to avoid a circular dep
PDEPEND="
	alsa? ( alsa-plugin? ( >=media-plugins/alsa-plugins-1.0.27-r1[pulseaudio,${MULTILIB_USEDEP}] ) )
"

# alsa-utils dep is for the alsasound init.d script (see bug #155707)
# bluez dep is for the bluetooth init.d script
# PyQt5 dep is for the qpaeq script
RDEPEND="${RDEPEND}
	equalizer? ( qt5? ( dev-python/PyQt5[dbus,widgets] ) )
	system-wide? (
		alsa? ( media-sound/alsa-utils )
		bluetooth? ( >=net-wireless/bluez-5 )
		acct-user/pulse
		acct-group/pulse-access
	)
	acct-group/audio
"

BDEPEND="
	doc? ( app-doc/doxygen )
	system-wide? ( dev-util/unifdef )
	test? ( >=dev-libs/check-0.9.10 )
	sys-devel/gettext
	sys-devel/m4
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/pulseaudio-11.1-disable-flat-volumes.patch # bug 627894
)

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
	gnome2_environment_reset #543364
}

src_prepare() {
	default

	# Skip test that cannot work with sandbox, bug #501846
	sed -i -e '/lock-autospawn-test /d' src/Makefile.am || die
	sed -i -e 's/lock-autospawn-test$(EXEEXT) //' src/Makefile.in || die

	eautoreconf
}

multilib_src_configure() {
	local myconf=(
		--disable-adrian-aec
		--disable-esound
		--disable-gconf
		--disable-solaris
		--enable-largefile
		--localstatedir="${EPREFIX}"/var
		--with-systemduserunitdir=$(systemd_get_userunitdir)
		--with-udev-rules-dir="${EPREFIX}/$(get_udevdir)"/rules.d
		$(multilib_native_use_enable alsa)
		$(multilib_native_use_enable bluetooth bluez5)
		$(multilib_native_use_enable glib gsettings)
		$(multilib_native_use_enable gtk gtk3)
		$(multilib_native_use_enable jack)
		$(multilib_native_use_enable libsamplerate samplerate)
		$(multilib_native_use_enable lirc)
		$(multilib_native_use_enable orc)
		$(multilib_native_use_enable oss oss-output)
		$(multilib_native_use_enable ssl openssl)
		# tests involve random modules, so just do them for the native
		$(multilib_native_use_enable test default-build-tests)
		$(multilib_native_use_enable udev)
		$(multilib_native_use_enable webrtc-aec)
		$(multilib_native_use_enable zeroconf avahi)
		$(multilib_native_use_with equalizer fftw)
		$(multilib_native_use_with sox soxr)
		$(multilib_native_usex gdbm '--with-database=gdbm' '--with-database=simple')
		$(use_enable glib glib2)
		$(use_enable asyncns)
		$(use_enable cpu_flags_arm_neon neon-opt)
		$(use_enable tcpd tcpwrap)
		$(use_enable dbus)
		$(use_enable X x11)
		$(use_enable systemd systemd-daemon)
		# systemd-login isn't necessary for non-native, but the rest of systemd are; not changing it at this point close to a meson port
		$(use_enable systemd systemd-login)
		$(use_enable systemd systemd-journal)
		$(use_enable ipv6)
		$(use_with caps)
	)

	if use elogind && multilib_is_native_abi; then
		local PKGCONFIG="$(tc-getPKG_CONFIG)"
		myconf+=(
			--enable-systemd-login
			SYSTEMDLOGIN_CFLAGS="$(${PKGCONFIG} --cflags "libelogind")"
			SYSTEMDLOGIN_LIBS="$(${PKGCONFIG} --libs "libelogind")"
		)
	fi

	if use bluetooth; then
		myconf+=(
			$(multilib_native_use_enable native-headset bluez5-native-headset)
			$(multilib_native_use_enable ofono-headset bluez5-ofono-headset)
		)
	fi

	if ! multilib_is_native_abi; then
		myconf+=(
			# hack around unnecessary checks
			# (results don't matter, we're not building anything using it)
			ac_cv_lib_ltdl_lt_dladvise_init=yes
			LIBSPEEX_CFLAGS=' '
			LIBSPEEX_LIBS=' '
		)
	else
		# Make padsp work for non-native ABI, supposedly only possible with glibc; this is used by /usr/bin/padsp that comes from native build, thus we need this argument for native build
		if use elibc_glibc ; then
			myconf+=( --with-pulsedsp-location="${EPREFIX}"'/usr/\\$$LIB/pulseaudio' )
		fi
	fi

	ECONF_SOURCE=${S} \
	econf "${myconf[@]}"
}

multilib_src_compile() {
	if multilib_is_native_abi; then
		emake
		use doc && emake doxygen
	else
		local targets=( libpulse.la libpulsedsp.la libpulse-simple.la )
		use glib && targets+=( libpulse-mainloop-glib.la )
		emake -C src ${targets[*]}
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
		if use doc ; then
			docinto html
			dodoc -r doxygen/html/
		fi
	else
		local targets=( libpulse.la libpulse-simple.la )
		use glib && targets+=( libpulse-mainloop-glib.la )
		emake DESTDIR="${D}" install-pkgconfigDATA
		emake DESTDIR="${D}" -C src \
			install-libLTLIBRARIES \
			install-padsplibLTLIBRARIES \
			lib_LTLIBRARIES="${targets[*]}" \
			install-pulseincludeHEADERS
	fi
}

multilib_src_install_all() {
	if use system-wide; then
		newconfd "${FILESDIR}/pulseaudio.conf.d" pulseaudio

		use_define() {
			local define=${2:-$(echo $1 | tr '[:lower:]' '[:upper:]')}

			use "$1" && echo "-D$define" || echo "-U$define"
		}

		unifdef $(use_define zeroconf AVAHI) \
			$(use_define alsa) \
			$(use_define bluetooth) \
			$(use_define udev) \
			"${FILESDIR}/pulseaudio.init.d-5" \
			> "${T}/pulseaudio"

		doinitd "${T}/pulseaudio"

		systemd_dounit "${FILESDIR}/${PN}.service"

		# We need /var/run/pulse, bug #442852
		newtmpfiles "${FILESDIR}/${PN}.tmpfiles" "${PN}.conf"
	else
		# Prevent warnings when system-wide is not used, bug #447694
		if use dbus ; then
			rm "${ED}"/etc/dbus-1/system.d/pulseaudio-system.conf || die
		fi
	fi

	if use zeroconf ; then
		sed -e '/module-zeroconf-publish/s:^#::' \
			-i "${ED}/etc/pulse/default.pa" || die
	fi

	dodoc NEWS README todo

	find "${ED}" \( -name '*.a' -o -name '*.la' \) -delete || die
}

pkg_postinst() {
	gnome2_schemas_update
	if use system-wide; then
		elog "You have enabled the 'system-wide' USE flag for pulseaudio."
		elog "This mode should only be used on headless servers, embedded systems,"
		elog "or thin clients. It will usually require manual configuration, and is"
		elog "incompatible with many expected pulseaudio features."
		elog "On normal desktop systems, system-wide mode is STRONGLY DISCOURAGED."
		elog "For more information, see"
		elog "    https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/WhatIsWrongWithSystemWide/"
		elog "    https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/SystemWide/"
		elog "    https://wiki.gentoo.org/wiki/PulseAudio#Headless_server"
	fi

	if use equalizer && ! use qt5; then
		elog "You've enabled the 'equalizer' USE-flag but not the 'qt5' USE-flag."
		elog "This will build the equalizer module, but the 'qpaeq' tool"
		elog "which is required to set equalizer levels will not work."
	fi

	if use equalizer && use qt5; then
		elog "You will need to load some extra modules to make qpaeq work."
		elog "You can do that by adding the following two lines in"
		elog "/etc/pulse/default.pa and restarting pulseaudio:"
		elog "load-module module-equalizer-sink"
		elog "load-module module-dbus-protocol"
	fi

	if use native-headset && use ofono-headset; then
		elog "You have enabled both native and ofono headset profiles. The runtime decision"
		elog "which to use is done via the 'headset' argument of module-bluetooth-discover."
	fi

	if use libsamplerate; then
		elog "The libsamplerate based resamplers are now deprecated, because they offer no"
		elog "particular advantage over speex. Upstream suggests disabling them."
	fi
}

pkg_postrm() {
	gnome2_schemas_update
}
