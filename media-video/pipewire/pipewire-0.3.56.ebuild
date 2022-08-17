# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# 1. Please regularly check (even at the point of bumping) Fedora's packaging
# for needed backports at https://src.fedoraproject.org/rpms/pipewire/tree/rawhide.
#
# 2. Upstream also sometimes amend release notes for the previous release to mention
# needed patches, e.g. https://gitlab.freedesktop.org/pipewire/pipewire/-/tags/0.3.55#distros
#
# 3. Keep an eye on git master (for both PipeWire and WirePlumber) as things
# continue to move quickly. It's not uncommon for fixes to be made shortly
# after releases.

PYTHON_COMPAT=( python3_{8..11} )

inherit flag-o-matic meson-multilib optfeature prefix python-any-r1 systemd udev

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/${PN}/${PN}.git"
	inherit git-r3
else
	if [[ ${PV} == *_p* ]] ; then
		MY_COMMIT=""
		SRC_URI="https://gitlab.freedesktop.org/pipewire/pipewire/-/archive/${MY_COMMIT}/pipewire-${MY_COMMIT}.tar.bz2 -> ${P}.tar.bz2"
		S="${WORKDIR}"/${PN}-${MY_COMMIT}
	else
		SRC_URI="https://gitlab.freedesktop.org/${PN}/${PN}/-/archive/${PV}/${P}.tar.gz"
	fi

	KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv ~sparc x86"
fi

DESCRIPTION="Multimedia processing graphs"
HOMEPAGE="https://pipewire.org/"

LICENSE="MIT LGPL-2.1+ GPL-2"
# ABI was broken in 0.3.42 for https://gitlab.freedesktop.org/pipewire/wireplumber/-/issues/49
SLOT="0/0.4"
IUSE="bluetooth dbus doc echo-cancel extra gstreamer jack-client jack-sdk lv2
pipewire-alsa sound-server ssl system-service systemd test udev v4l X zeroconf"

# Once replacing system JACK libraries is possible, it's likely that
# jack-client IUSE will need blocking to avoid users accidentally
# configuring their systems to send PW sink output to the emulated
# JACK's sink - doing so is likely to yield no audio, cause a CPU
# cycles consuming loop (and may even cause GUI crashes)!

# TODO: There should be "sound-server? ( || ( alsa bluetooth ) )" here, but ALSA is always enabled
# TODO: Pulseaudio alsa plugin performs runtime check that pulseaudio server connection will work
# which provides adequate guarantee that alsa-lib will be able to provide audio services.
# If that works, pulseaudio defaults are loaded into alsa-lib runtime replacing default PCM and CTL.
# When pipewire-alsa will be able to perform similar check, pipewire-alsa can be enabled unconditionally.
REQUIRED_USE="
	jack-sdk? ( !jack-client )
	system-service? ( systemd )
	!sound-server? ( !pipewire-alsa )
	jack-client? ( dbus )
"

RESTRICT="!test? ( test )"

BDEPEND="
	>=dev-util/meson-0.59
	virtual/pkgconfig
	${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-python/docutils[${PYTHON_USEDEP}]')
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)
"
RDEPEND="
	acct-group/audio
	media-libs/alsa-lib
	sys-libs/readline:=
	sys-libs/ncurses:=[unicode(+)]
	virtual/libintl[${MULTILIB_USEDEP}]
	bluetooth? (
		media-libs/fdk-aac
		media-libs/libldac
		media-libs/libfreeaptx
		media-libs/sbc
		>=net-wireless/bluez-4.101:=
		virtual/libusb:1
	)
	dbus? ( sys-apps/dbus[${MULTILIB_USEDEP}] )
	echo-cancel? ( media-libs/webrtc-audio-processing:0 )
	extra? (
		>=media-libs/libsndfile-1.0.20
	)
	gstreamer? (
		>=dev-libs/glib-2.32.0:2
		>=media-libs/gstreamer-1.10.0:1.0
		media-libs/gst-plugins-base:1.0
	)
	jack-client? ( >=media-sound/jack2-1.9.10:2[dbus] )
	jack-sdk? (
		!media-sound/jack-audio-connection-kit
		!media-sound/jack2
	)
	lv2? ( media-libs/lilv )
	pipewire-alsa? (
		>=media-libs/alsa-lib-1.1.7[${MULTILIB_USEDEP}]
	)
	sound-server? (
		!media-sound/pulseaudio[daemon(+)]
		!media-sound/pulseaudio-daemon
	)
	ssl? ( dev-libs/openssl:= )
	systemd? ( sys-apps/systemd )
	system-service? (
		acct-user/pipewire
		acct-group/pipewire
	)
	udev? ( virtual/libudev[${MULTILIB_USEDEP}] )
	v4l? ( media-libs/libv4l )
	X? (
		media-libs/libcanberra
		x11-libs/libX11
		x11-libs/libXfixes
	)
	zeroconf? ( net-dns/avahi )
"

DEPEND="${RDEPEND}"

# TODO: Consider use cases where pipewire is not used for driving audio
# Doing so with WirePlumber currently involves editing Lua scripts
PDEPEND=">=media-video/wireplumber-0.4.8-r3"

# Present RDEPEND that are currently always disabled due to the PW
# code using them being required to be disabled by Gentoo guidelines
# (i.e. developer binaries not meant for users) and unready code
#	media-video/ffmpeg:=
#	media-libs/libsdl2
#	>=media-libs/vulkan-loader-1.1.69
#
# Ditto for DEPEND
#	>=dev-util/vulkan-headers-1.1.69

DOCS=( {README,INSTALL}.md NEWS )

PATCHES=(
	"${FILESDIR}"/${PN}-0.3.25-enable-failed-mlock-warning.patch
	"${FILESDIR}"/${P}-big-endian.patch
)

# limitsdfile related code taken from =sys-auth/realtime-base-0.1
# with changes as necessary.
limitsdfile=40-${PN}.conf

python_check_deps() {
	python_has_version "dev-python/docutils[${PYTHON_USEDEP}]"
}

src_prepare() {
	default

	einfo "Generating ${limitsdfile}"
	cat > ${limitsdfile} <<- EOF || die
		# Start of ${limitsdfile} from ${P}

		@audio	-	memlock 256

		$(use system-service && {
			echo @pipewire - rtprio 95
			echo @pipewire - nice -19
			echo @pipewire - memlock 4194304
		})

		# End of ${limitsdfile} from ${P}
	EOF
}

multilib_src_configure() {
	# https://bugs.gentoo.org/838301
	filter-flags -fno-semantic-interposition

	local emesonargs=(
		-Ddocdir="${EPREFIX}"/usr/share/doc/${PF}

		$(meson_feature dbus)
		$(meson_native_use_feature zeroconf avahi)
		$(meson_native_use_feature doc docs)
		$(meson_native_enabled examples) # TODO: Figure out if this is still important now that media-session gone
		$(meson_native_enabled man)
		$(meson_feature test tests)
		-Dinstalled_tests=disabled # Matches upstream; Gentoo never installs tests
		$(meson_native_use_feature gstreamer)
		$(meson_native_use_feature gstreamer gstreamer-device-provider)
		$(meson_native_use_feature systemd)

		$(meson_native_use_feature system-service systemd-system-service)
		-Dsystemd-system-unit-dir="$(systemd_get_systemunitdir)"
		-Dsystemd-user-unit-dir="$(systemd_get_userunitdir)"

		$(meson_native_use_feature systemd systemd-user-service)
		$(meson_feature pipewire-alsa) # Allows integrating ALSA apps into PW graph
		-Dspa-plugins=enabled
		-Dalsa=enabled # Allows using kernel ALSA for sound I/O (NOTE: media-session is gone so IUSE=alsa/spa_alsa/alsa-backend might be possible)
		-Daudiomixer=enabled # Matches upstream
		-Daudioconvert=enabled # Matches upstream
		$(meson_native_use_feature bluetooth bluez5)
		$(meson_native_use_feature bluetooth bluez5-backend-hsp-native)
		$(meson_native_use_feature bluetooth bluez5-backend-hfp-native)
		$(meson_native_use_feature bluetooth bluez5-backend-ofono)
		$(meson_native_use_feature bluetooth bluez5-backend-hsphfpd)
		$(meson_native_use_feature bluetooth bluez5-codec-aac)
		$(meson_native_use_feature bluetooth bluez5-codec-aptx)
		$(meson_native_use_feature bluetooth bluez5-codec-ldac)
		$(meson_native_use_feature bluetooth libusb) # At least for now only used by bluez5 native (quirk detection of adapters)
		$(meson_native_use_feature echo-cancel echo-cancel-webrtc) #807889
		# Not yet packaged.
		-Dbluez5-codec-lc3plus=disabled
		-Dcontrol=enabled # Matches upstream
		-Daudiotestsrc=enabled # Matches upstream
		-Dffmpeg=disabled # Disabled by upstream and no major developments to spa/plugins/ffmpeg/ since May 2020
		-Dpipewire-jack=enabled # Allows integrating JACK apps into PW graph
		$(meson_native_use_feature jack-client jack) # Allows PW to act as a JACK client
		$(meson_use jack-sdk jack-devel)
		$(usex jack-sdk "-Dlibjack-path=${EPREFIX}/usr/$(get_libdir)" '')
		-Dsupport=enabled # Miscellaneous/common plugins, such as null sink
		-Devl=disabled # Matches upstream
		-Dtest=disabled # fakesink and fakesource plugins
		$(meson_native_use_feature lv2)
		$(meson_native_use_feature v4l v4l2)
		-Dlibcamera=disabled # libcamera is not in Portage tree
		$(meson_native_use_feature ssl raop)
		-Dvideoconvert=enabled # Matches upstream
		-Dvideotestsrc=enabled # Matches upstream
		-Dvolume=enabled # Matches upstream
		-Dvulkan=disabled # Uses pre-compiled Vulkan compute shader to provide a CGI video source (dev thing; disabled by upstream)
		$(meson_native_use_feature extra pw-cat)
		$(meson_feature udev)
		-Dudevrulesdir="${EPREFIX}$(get_udevdir)/rules.d"
		-Dsdl2=disabled # Controls SDL2 dependent code (currently only examples when -Dinstalled_tests=enabled which we never install)
		$(meson_native_use_feature extra sndfile) # Enables libsndfile dependent code (currently only pw-cat)
		-Dsession-managers="[]" # All available session managers are now their own projects, so there's nothing to build

		# Just for bell sounds in X11 right now.
		$(meson_native_use_feature X x11)
		$(meson_native_use_feature X x11-xfixes)
		$(meson_native_use_feature X libcanberra)
	)

	meson_src_configure
}

multilib_src_install() {
	# Our custom DOCS do not exist in multilib source directory
	DOCS= meson_src_install
}

multilib_src_install_all() {
	einstalldocs

	insinto /etc/security/limits.d
	doins ${limitsdfile}

	if use pipewire-alsa; then
		dodir /etc/alsa/conf.d

		# Install pipewire conf loader hook
		insinto /usr/share/alsa/alsa.conf.d
		doins "${FILESDIR}"/99-pipewire-default-hook.conf
		eprefixify "${ED}"/usr/share/alsa/alsa.conf.d/99-pipewire-default-hook.conf

		# These will break if someone has /etc that is a symbolic link to a subfolder! See #724222
		# And the current dosym8 -r implementation is likely affected by the same issue, too.
		dosym ../../../usr/share/alsa/alsa.conf.d/50-pipewire.conf /etc/alsa/conf.d/50-pipewire.conf
		dosym ../../../usr/share/alsa/alsa.conf.d/99-pipewire-default-hook.conf /etc/alsa/conf.d/99-pipewire-default-hook.conf
	fi

	# Enable required wireplumber alsa and bluez monitors
	if use sound-server; then
		dodir /etc/wireplumber/main.lua.d
		echo "alsa_monitor.enabled = true" > "${ED}"/etc/wireplumber/main.lua.d/89-gentoo-sound-server-enable-alsa-monitor.lua || die

		dodir /etc/wireplumber/bluetooth.lua.d
		echo "bluez_monitor.enabled = true" > "${ED}"/etc/wireplumber/bluetooth.lua.d/89-gentoo-sound-server-enable-bluez-monitor.lua || die
	fi

	if ! use systemd; then
		insinto /etc/xdg/autostart
		newins "${FILESDIR}"/pipewire.desktop-r1 pipewire.desktop

		exeinto /usr/bin
		newexe "${FILESDIR}"/gentoo-pipewire-launcher.in gentoo-pipewire-launcher

		# Disable pipewire-pulse if sound-server is disabled.
		if ! use sound-server ; then
			sed -i -s '/pipewire -c pipewire-pulse.conf/s/^/#/' "${ED}"/usr/bin/gentoo-pipewire-launcher || die
		fi

		eprefixify "${ED}"/usr/bin/gentoo-pipewire-launcher
	fi
}

pkg_postrm() {
	use udev && udev_reload
}

pkg_postinst() {
	use udev && udev_reload

	elog "It is recommended to raise RLIMIT_MEMLOCK to 256 for users"
	elog "using PipeWire. Do it either manually or add yourself"
	elog "to the 'audio' group:"
	elog
	elog "  usermod -aG audio <youruser>"
	elog

	local ver
	for ver in ${REPLACING_VERSIONS} ; do
		if ver_test ${ver} -le 0.3.53-r1 && ! use sound-server ; then
			ewarn "USE=sound-server is disabled! If you want PipeWire to provide"
			ewarn "your sound, please enable it. See the wiki at"
			ewarn "https://wiki.gentoo.org/wiki/PipeWire#Replacing_PulseAudio"
			ewarn "for more details."

			break
		fi
	done

	if ! use jack-sdk; then
		elog "JACK emulation is incomplete and not all programs will work. PipeWire's"
		elog "alternative libraries have been installed to a non-default location."
		elog "To use them, put pw-jack <application> before every JACK application."
		elog "When using pw-jack, do not run jackd/jackdbus. However, a virtual/jack"
		elog "provider is still needed to compile the JACK applications themselves."
		elog
	fi

	if use systemd; then
		elog "When switching from PulseAudio, you may need to disable PulseAudio:"
		elog
		elog "  systemctl --user disable pulseaudio.service pulseaudio.socket"
		elog
		elog "To use PipeWire, the user units must be manually enabled"
		elog "by running this command as each user you use for desktop activities:"
		elog
		elog "  systemctl --user enable pipewire.socket pipewire-pulse.socket"
		elog
		elog "A reboot is recommended to avoid interferences from still running"
		elog "PulseAudio daemon."
		elog
		elog "Both new users and those upgrading need to enable WirePlumber"
		elog "for relevant users:"
		elog
		elog "  systemctl --user disable pipewire-media-session.service"
		elog "  systemctl --user --force enable wireplumber.service"
		elog
		elog "Root user may replace --user with --global to change system default"
		elog "configuration for all of the above commands."
	else
		ewarn "PipeWire daemon startup has been moved to a launcher script!"
		ewarn "Make sure that ${EROOT}/etc/pipewire/pipewire.conf either does not exist or no"
		ewarn "longer is set to start a session manager or PulseAudio compatibility daemon (all"
		ewarn "lines similar to '{ path = /usr/bin/pipewire*' should be commented out)"
		ewarn
		ewarn "Those manually starting /usr/bin/pipewire via .xinitrc or similar _must_ from"
		ewarn "now on start ${EROOT}/usr/bin/gentoo-pipewire-launcher instead! It is highly"
		ewarn "advised that a D-Bus user session is set up before starting the script."
		ewarn

		if use sound-server && ( has_version 'media-sound/pulseaudio[daemon]' || has_version 'media-sound/pulseaudio-daemon' ) ; then
			elog "This ebuild auto-enables PulseAudio replacement. Because of that, users"
			elog "are recommended to edit pulseaudio client configuration files:"
			elog "${EROOT}/etc/pulse/client.conf and ${EROOT}/etc/pulse/client.conf.d/enable-autospawn.conf"
			elog "if it exists, and disable autospawning of the original daemon by setting:"
			elog
			elog "  autospawn = no"
			elog
			elog "Please note that the semicolon (;) must _NOT_ be at the beginning of the line!"
			elog
			elog "Alternatively, if replacing PulseAudio daemon is not desired, edit"
			elog "${EROOT}/usr/bin/gentoo-pipewire-launcher by commenting out the relevant"
			elog "command:"
			elog
			elog "#${EROOT}/usr/bin/pipewire -c pipewire-pulse.conf &"
			elog
		fi
		elog "NOTE:"
		elog "Starting with PipeWire-0.3.30, this package is no longer installing its config"
		elog "into ${EROOT}/etc/pipewire by default. In case you need to change"
		elog "its config, please start by copying default config from ${EROOT}/usr/share/pipewire"
		elog "and just override the sections you want to change."
	fi
	elog

	elog "For latest tips and tricks, troubleshooting information and documentation"
	elog "in general, please refer to https://wiki.gentoo.org/wiki/PipeWire"
	elog

	optfeature_header "The following can be installed for optional runtime features:"
	optfeature "restricted realtime capabilities via D-Bus" sys-auth/rtkit

	if use sound-server && ! use pipewire-alsa; then
		optfeature "ALSA plugin to use PulseAudio interface for output" "media-plugins/alsa-plugins[pulseaudio]"
	fi

	if has_version 'net-misc/ofono' ; then
		ewarn "Native backend has become default. Please disable oFono via:"
		if systemd_is_booted ; then
			ewarn "systemctl disable ofono"
		else
			ewarn "rc-update delete ofono"
		fi
		ewarn
	fi

	if use system-service; then
		ewarn
		ewarn "WARNING: you have enabled the system-service USE flag, which installs"
		ewarn "the system-wide systemd units that enable PipeWire to run as a system"
		ewarn "service. This is more than likely NOT what you want. You are strongly"
		ewarn "advised not to enable this mode and instead stick with systemd user"
		ewarn "units. The default configuration files will likely not work out of"
		ewarn "box, and you are on your own with configuration."
		ewarn
	fi
}
