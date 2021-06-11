# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson-multilib bash-completion-r1 gnome2-utils optfeature systemd udev

# When COMMIT is defined, this ebuild turns from a release into a snapshot ebuild:
COMMIT="79cb1369fc4d22966cb65253e9da2ccda2f25b45"
# Also set SNAPSHOT_PV to match the expected PV, so that the ebuild can detect a naive rename:
SNAPSHOT_PV="14.99.1_p20210607"
# When COMMIT is defined, this enables a PA specific work-around for missing .tarball-version file:
SNAPSHOT_FIX_GITVERSION=1

DESCRIPTION="A networked sound server with an advanced plugin system"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/PulseAudio/"
if [[ ${PV} = 9999 ]]; then
	inherit git-r3
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://gitlab.freedesktop.org/${PN}/${PN}"
else
	if [[ -n ${COMMIT} ]]; then
		SRC_URI="https://gitlab.freedesktop.org/${PN}/${PN}/-/archive/${COMMIT}/${PN}-${COMMIT}.tar.gz -> ${P}.tar.gz"
		S="${WORKDIR}"/${PN}-${COMMIT}
	else
		SRC_URI="https://freedesktop.org/software/${PN}/releases/${P}.tar.xz"
	fi
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
fi
# libpulse-simple and libpulse link to libpulse-core; this is daemon's
# library and can link to gdbm and other GPL-only libraries. In this
# cases, we have a fully GPL-2 package. Leaving the rest of the
# GPL-forcing USE flags for those who use them.
LICENSE="!gdbm? ( LGPL-2.1 ) gdbm? ( GPL-2 )"

SLOT="0"

# +alsa-plugin as discussed in bug #519530
# TODO: Deal with bluez5-gstreamer
# TODO: Find out why webrtc-aec is + prefixed - there's already the always available speexdsp-aec
# NOTE: The current ebuild sets +X almost certainly just for the pulseaudio.desktop file
IUSE="+alsa +alsa-plugin +asyncns bluetooth dbus +daemon doc elogind equalizer forget-missing +gdbm
gstreamer +glib gtk ipv6 jack lirc native-headset ofono-headset +orc oss selinux sox ssl systemd
system-wide tcpd test +udev +webrtc-aec +X zeroconf"

RESTRICT="!test? ( test )"

# See "*** BLUEZ support not found (requires D-Bus)" in configure.ac
# Basically all IUSE are either ${MULTILIB_USEDEP} for client libs or they belong under !daemon ()
# We duplicate alsa-plugin, {native,ofono}-headset under daemon to let users deal with them at once
REQUIRED_USE="
	alsa-plugin? ( alsa )
	bluetooth? ( dbus )
	daemon? ( ?? ( elogind systemd ) )
	!daemon? (
		!alsa
		!alsa-plugin
		!bluetooth
		!equalizer
		!gdbm
		!gtk
		!jack
		!lirc
		!native-headset
		!ofono-headset
		!orc
		!oss
		!sox
		!ssl
		!system-wide
		!udev
		!webrtc-aec
		!zeroconf
	)
	equalizer? ( dbus )
	native-headset? ( bluetooth )
	ofono-headset? ( bluetooth )
	udev? ( || ( alsa oss ) )
	zeroconf? ( dbus )
"

# libpcre needed in some cases, bug #472228 # TODO: Read it
RDEPEND="
	virtual/libc
	>=media-libs/libsndfile-1.0.20[${MULTILIB_USEDEP}]
	X? (
		>=x11-libs/libxcb-1.6[${MULTILIB_USEDEP}]
		daemon? (
			>=x11-libs/libX11-1.4.0
			x11-libs/libSM
			x11-libs/libICE
			>=x11-libs/libXtst-1.0.99.2
		)
	)
	>=sys-libs/libcap-2.22-r2
	alsa? ( >=media-libs/alsa-lib-1.0.24 )
	glib? ( >=dev-libs/glib-2.28.0:2[${MULTILIB_USEDEP}] )
	zeroconf? ( >=net-dns/avahi-0.6.12[dbus] )
	jack? ( virtual/jack )
	tcpd? ( sys-apps/tcp-wrappers[${MULTILIB_USEDEP}] )
	lirc? ( app-misc/lirc )
	dbus? ( >=sys-apps/dbus-1.4.12[${MULTILIB_USEDEP}] )
	gtk? ( x11-libs/gtk+:3 )
	bluetooth? (
		>=net-wireless/bluez-5
		media-libs/sbc
	)
	asyncns? ( >=net-libs/libasyncns-0.1[${MULTILIB_USEDEP}] )
	udev? ( >=virtual/udev-143[hwdb(+)] )
	equalizer? (
		sci-libs/fftw:3.0
	)
	ofono-headset? ( >=net-misc/ofono-1.13 )
	orc? ( >=dev-lang/orc-0.4.15 )
	sox? ( >=media-libs/soxr-0.1.1 )
	ssl? ( dev-libs/openssl:= )
	>=media-libs/speexdsp-1.2[${MULTILIB_USEDEP}]
	gdbm? ( sys-libs/gdbm:= )
	webrtc-aec? ( >=media-libs/webrtc-audio-processing-0.2 )
	elogind? ( sys-auth/elogind )
	systemd? ( sys-apps/systemd:=[${MULTILIB_USEDEP}] )
	daemon? (
		dev-libs/libltdl
		sys-kernel/linux-headers
	)
	selinux? ( sec-policy/selinux-pulseaudio )
	gstreamer? (
		media-libs/gst-plugins-base
		>=media-libs/gstreamer-1.14
	)
"

DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )
	dev-libs/libatomic_ops
"
# This is a PDEPEND to avoid a circular dep
PDEPEND="
	alsa? ( alsa-plugin? ( >=media-plugins/alsa-plugins-1.0.27-r1[pulseaudio,${MULTILIB_USEDEP}] ) )
"

# alsa-utils dep is for the alsasound init.d script (see bug 155707); TODO: read it
# NOTE: Only system-wide needs acct-group/audio unless elogind/systemd is not used
RDEPEND="${RDEPEND}
	system-wide? (
		alsa? ( media-sound/alsa-utils )
		acct-user/pulse
		acct-group/audio
		acct-group/pulse-access
	)
"

# NOTE: dev-libs/libpcre header will be used if found but no linking is done on non-Windows
BDEPEND="
	doc? ( app-doc/doxygen )
	orc? ( >=dev-lang/orc-0.4.15 )
	system-wide? ( dev-util/unifdef )
	test? ( >=dev-libs/check-0.9.10 )
	dev-libs/libpcre
	sys-devel/gettext
	sys-devel/m4
	virtual/libiconv
	virtual/libintl
	virtual/pkgconfig
"

DOCS=( NEWS README ) # todo is useless to install

pkg_pretend() {
	if [[ -n ${COMMIT} && -z ${SNAPSHOT_PV} || -z ${COMMIT} && -n ${SNAPSHOT_PV} ]]; then
		eerror "Please either set both COMMIT and SNAPSHOT_PV or neither!"
	elif [[ -n ${SNAPSHOT_PV} && ${PV} != ${SNAPSHOT_PV} ]]; then
		die "Rename of snapshot ebuild detected - please check COMMIT & SNAPSHOT_PV!"
	fi
}

pkg_setup() {
	gnome2_environment_reset # bug 543364 # TODO: read it
}

src_prepare() {
	default

	if [[ -n ${COMMIT} ]]; then
		# This file really should be upstream's responsibility but what can you do other than hack
		# together a work-around for an upstream's tarball generator lacking required integration?
		if [[ -n ${SNAPSHOT_FIX_GITVERSION} && ${SNAPSHOT_FIX_GITVERSION} -ge 1 ]]; then
			echo ${PV%_*}-${COMMIT:0:8} > .tarball-version
		fi
	fi
}

multilib_src_configure() {
	local emesonargs=(
		-Dadrian-aec=false # Not packaged?
		--localstatedir="${EPREFIX}"/var
		-Dmodlibexecdir="${EPREFIX}/usr/$(get_libdir)/${PN}/modules" # Was $(get_libdir)/${P}
#		-Dsystemduserunitdir=$(systemd_get_userunitdir)
		-Dudevrulesdir="$(get_udevdir)"/rules.d
		-Dbashcompletiondir="$(get_bashcompdir)" # Alternatively DEPEND on app-shells/bash-completion for pkg-config to provide the value
		$(meson_native_use_feature alsa)
		$(meson_native_use_bool bluetooth bluez5)
		$(meson_native_use_bool daemon)
		$(meson_native_use_bool native-headset bluez5-native-headset)
		$(meson_native_use_bool ofono-headset bluez5-ofono-headset)
		$(meson_native_use_feature glib gsettings) # Supposedly correct?
		$(meson_native_use_feature gstreamer)
		$(meson_native_use_feature gtk)
		$(meson_native_use_feature jack)
		-Dsamplerate=disabled # Matches upstream
		$(meson_native_use_feature lirc)
		$(meson_native_use_feature orc)
		$(meson_native_use_feature oss oss-output)
		$(meson_native_use_feature ssl openssl)
		# tests involve random modules, so just do them for the native # TODO: tests should run always
		$(meson_native_use_bool test tests)
		$(meson_native_use_feature udev)
		$(meson_native_use_feature webrtc-aec)
		$(meson_native_use_feature zeroconf avahi)
		$(meson_native_use_feature equalizer fftw)
		$(meson_native_use_feature sox soxr)
		-Ddatabase=$(multilib_native_usex gdbm gdbm simple) # tdb is also an option but no one cares about it
		$(meson_use forget-missing stream-restore-clear-old-devices)
		$(meson_feature glib) # WARNING: toggling this likely changes ABI
		$(meson_feature asyncns)
		#$(meson_use cpu_flags_arm_neon neon-opt)
		$(meson_feature tcpd tcpwrap) # TODO: system-wide specific?
		$(meson_feature dbus)
		$(meson_feature elogind)
		$(meson_feature X x11)
		$(meson_feature systemd)
		$(meson_use ipv6)
	)

	if multilib_is_native_abi; then
		# Make padsp work for non-native ABI, supposedly only possible with glibc; this is used by /usr/bin/padsp that comes from native build, thus we need this argument for native build
		if use elibc_glibc; then
			emesonargs+=( -Dpulsedsp-location="${EPREFIX}"'/usr/\\$$LIB/pulseaudio' )
		fi
	else
		if ! use elibc_glibc; then
			# Non-glibc multilib is probably non-existent but just in case:
			ewarn "padsp wrapper for OSS emulation will only work with native ABI applications!"
		fi
	fi

	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile

	if multilib_is_native_abi; then
		use doc && meson_src_compile doxygen
	fi
}

multilib_src_install() {
	# The files referenced in the DOCS array do not exist in the multilib source directory,
	# therefore clear the variable when calling the function that will access it.
	DOCS= meson_src_install
}

multilib_src_install_all() {
	# Now we can install the DOCS. ;)
	einstalldocs

	if use doc; then
		# TODO: check it's installing into the right place
		docinto html
		dodoc -r doxygen/html/
	fi

	if use system-wide; then
		newconfd "${FILESDIR}"/pulseaudio.conf.d pulseaudio

		use_define() {
			local define=${2:-$(echo $1 | tr '[:lower:]' '[:upper:]')}

			use "$1" && echo "-D$define" || echo "-U$define"
		}

		unifdef $(use_define zeroconf AVAHI) \
			$(use_define alsa) \
			$(use_define bluetooth) \
			$(use_define udev) \
			"${FILESDIR}"/pulseaudio.init.d-5 \
			> "${T}"/pulseaudio || die

		doinitd "${T}"/pulseaudio

		systemd_dounit "${FILESDIR}"/${PN}.service

		# We need /var/run/pulse, bug 442852
		systemd_newtmpfilesd "${FILESDIR}"/${PN}.tmpfiles ${PN}.conf
	else
		# Prevent warnings when system-wide is not used, bug 447694
		if use dbus && use daemon; then
			rm "${ED}"/etc/dbus-1/system.d/pulseaudio-system.conf || die
		fi
	fi

	if use zeroconf; then
		sed -e '/module-zeroconf-publish/s:^#::' \
			-i "${ED}/etc/pulse/default.pa" || die
	fi

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

	if use equalizer; then
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

	if use systemd && use daemon; then
		elog "It's recommended to start pulseaudio via its systemd user units:"
		elog "systemctl --user enable pulseaudio.service pulseaudio.socket"
		elog "The change from autospawn to user units will take effect after restarting."
	fi

	optfeature_header "PulseAudio can be enhanced by installing the following:"
	use equalizer && optfeature "using the qpaeq script" dev-python/PyQt5[dbus,widgets]
	use dbus && optfeature "restricted realtime capabilities vai D-Bus" sys-auth/rtkit
}

pkg_postrm() {
	gnome2_schemas_update
}
