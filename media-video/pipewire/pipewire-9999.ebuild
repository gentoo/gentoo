# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson optfeature udev multilib-minimal

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/${PN}/${PN}.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://gitlab.freedesktop.org/${PN}/${PN}/-/archive/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
fi

DESCRIPTION="Multimedia processing graphs"
HOMEPAGE="https://pipewire.org/"

LICENSE="LGPL-2.1+"
SLOT="0/0.3"
IUSE="aac aptx bluetooth doc extra gstreamer jack-client jack-sdk ldac pipewire-alsa systemd test v4l"

# Once replacing system JACK libraries is possible, it's likely that
# jack-client IUSE will need blocking to avoid users accidentally
# configuring their systems to send PW sink output to the emulated
# JACK's sink - doing so is likely to yield no audio, cause a CPU
# cycles consuming loop (and may even cause GUI crashes)!

REQUIRED_USE="
	aac? ( bluetooth )
	aptx? ( bluetooth )
	jack-sdk? ( !jack-client )
	ldac? ( bluetooth )
"

BDEPEND="
	app-doc/xmltoman
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)
"
RDEPEND="
	media-libs/alsa-lib
	sys-apps/dbus[${MULTILIB_USEDEP}]
	sys-libs/ncurses[unicode]
	virtual/libintl[${MULTILIB_USEDEP}]
	virtual/libudev[${MULTILIB_USEDEP}]
	bluetooth? (
		aac? ( media-libs/fdk-aac )
		aptx? ( media-libs/libopenaptx )
		ldac? ( media-libs/libldac )
		media-libs/sbc
		>=net-wireless/bluez-4.101:=
	)
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
	pipewire-alsa? (
		>=media-libs/alsa-lib-1.1.7[${MULTILIB_USEDEP}]
		|| (
			media-plugins/alsa-plugins[-pulseaudio]
			!media-plugins/alsa-plugins
		)
	)
	!pipewire-alsa? ( media-plugins/alsa-plugins[${MULTILIB_USEDEP},pulseaudio] )
	systemd? ( sys-apps/systemd )
	v4l? ( media-libs/libv4l )
"

DEPEND="${RDEPEND}"

# Present RDEPEND that are currently always disabled due to the PW
# code using them being required to be disabled by Gentoo guidelines
# (i.e. developer binaries not meant for users) and unready code
#	media-video/ffmpeg:=
#	media-libs/libsdl2
#	>=media-libs/vulkan-loader-1.1.69
#
# Ditto for DEPEND
#	>=dev-util/vulkan-headers-1.1.69

# It appears that meson.eclass with multilib-minimal.eclass breaks dodoc itself
#DOCS=( {README,INSTALL}.md NEWS )

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.3.25-enable-failed-mlock-warning.patch
)

# limitsdfile related code taken from =sys-auth/realtime-base-0.1
# with changes as necessary.
limitsdfile=00-${PN}.conf

# Copied with modifications from media-sound/pulseaudio-9999 from b.g.o (has sign-offs)
meson_native_feature() {
	echo "-D${2:-${1}}=$(multilib_native_usex ${1} enabled disabled)"
}

meson_native_enabled() {
	if multilib_is_native_abi; then
		echo "-D${1}=enabled"
	else
		echo "-D${1}=disabled"
	fi
}

src_prepare() {
	default

	if ! use systemd; then
		# This can be applied non-conditionally but would make for a
		# significantly worse user experience on systemd then.
		eapply "${FILESDIR}"/${PN}-0.3.25-non-systemd-integration.patch
	fi
}

multilib_src_configure() {
	local emesonargs=(
		-Ddocdir="${EPREFIX}"/usr/share/doc/${PF}
		$(meson_native_feature doc docs)
		$(meson_native_enabled examples) # Disabling this implicitly disables -Dmedia-session (not good)
		$(meson_native_enabled media-session)
		$(meson_native_enabled man)
		$(meson_feature test tests)
		-Dinstalled_tests=disabled # Matches upstream; Gentoo never installs tests
		$(meson_native_feature gstreamer)
		$(meson_native_feature gstreamer gstreamer-device-provider)
		$(meson_native_feature systemd) # Also covers logind integration
		-Dsystemd-system-service=disabled # Matches upstream
		$(meson_native_feature systemd systemd-user-service)
		$(meson_feature pipewire-alsa) # Allows integrating ALSA apps into PW graph
		$(meson_feature jack-sdk jack-devel) # Installs jack headers and jack.pc
		-Dpipewire-jack=enabled # Allows integrating JACK apps into PW graph
		$(usex jack-sdk "-Dlibjack-path=${EPREFIX}/usr/$(get_libdir)" '') # Where to install libjack.so et al (setting this will also break pw-jack's multilib support (but presumably that's okay as the intended use would be to replace system's libraries making the loader irrelevant)
		-Dspa-plugins=enabled # Trying to disable plugins breaks non-native tests
		-Dalsa=enabled # -Dmedia-session & -Dpipewire-alsa depend on this
		-Daudiomixer=enabled # Matches upstream
		-Daudioconvert=enabled # Matches upstream
		$(meson_native_feature bluetooth bluez5)
		$(meson_native_feature bluetooth bluez5-backend-hsp-native)
		$(meson_native_feature bluetooth bluez5-backend-hfp-native)
		$(meson_native_feature bluetooth bluez5-backend-ofono)
		$(meson_native_feature bluetooth bluez5-backend-hsphfpd)
		$(meson_native_feature aac bluez5-codec-aac)
		$(meson_native_feature aptx bluez5-codec-aptx)
		$(meson_native_feature ldac bluez5-codec-ldac)
		-Dcontrol=enabled # Matches upstream
		-Daudiotestsrc=enabled # Matches upstream
		-Dffmpeg=disabled # Disabled by upstream and no major developments to spa/plugins/ffmpeg/ since May 2020
		$(meson_native_feature jack-client jack) # Allows PW to act as a JACK client
		-Dsupport=enabled # Miscellaneous/common plugins, such as null sink
		-Devl=disabled # Matches upstream
		-Dtest=disabled # fakesink and fakesource plugins
		$(meson_native_feature v4l v4l2)
		-Dlibcamera=disabled # libcamera is not in Portage tree
		-Dvideoconvert=enabled # Matches upstream
		-Dvideotestsrc=enabled # Matches upstream
		-Dvolume=enabled # Matches upstream
		-Dvulkan=disabled # Uses pre-compiled Vulkan compute shader to provide a CGI video source (dev thing; disabled by upstream)
		$(meson_native_feature extra pw-cat)
		-Dudev=enabled # -Dalsa independently enables udev internally
		-Dudevrulesdir="$(get_udevdir)/rules.d"
		-Dsdl2=disabled # Controls SDL2 dependent code (currently only examples when -Dinstalled_tests=enabled which we never install)
		$(meson_native_feature extra sndfile) # Enables libsndfile dependent code (currently only pw-cat)
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile

	if multilib_is_native_abi; then
		einfo "Generating ${limitsdfile}"
		cat > ${limitsdfile} <<- EOF || die
			# Start of ${limitsdfile} from ${P}

			*	-	memlock 256

			# End of ${limitsdfile} from ${P}
		EOF
	fi
}

multilib_src_test() {
	meson_src_test
}

multilib_src_install() {
	meson_src_install

	if multilib_is_native_abi; then
		insinto /etc/security/limits.d
		doins ${limitsdfile}

		if use pipewire-alsa; then
			dodir /etc/alsa/conf.d
			# These will break if someone has /etc that is a symbol link to a subfolder! See #724222
			# And the current dosym8 -r implementation is likely affected by the same issue, too.
			dosym ../../../usr/share/alsa/alsa.conf.d/50-pipewire.conf /etc/alsa/conf.d/50-pipewire.conf
			dosym ../../../usr/share/alsa/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d/99-pipewire-default.conf
		fi

		if ! use systemd; then
			insinto /etc/xdg/autostart
			newins "${FILESDIR}"/pipewire.desktop pipewire.desktop

			exeinto /usr/libexec
			newexe "${FILESDIR}"/pipewire-launcher.sh pipewire-launcher
		fi
	fi
}

pkg_postinst() {
	if ! use pipewire-alsa; then
		elog "Contrary to what some online resources may suggest, avoid setting"
		elog "PULSE_LATENCY_MSEC environment variable since it may break ALSA clients."
		elog
	fi

	elog "JACK emulation is incomplete and not all programs will work."
	if ! use jack-sdk; then
		elog "PipeWire's JACK libraries have been installed outside LD search paths."
		elog "To use them, put pw-jack <application> before every JACK application."
		elog "When using pw-jack, do not run jackd/jackdbus. However, a virtual/jack"
		elog "provider is still needed to compile the JACK applications themselves."
	fi
	elog

	if use systemd; then
		elog "To use pipewire for audio the user units must be manually enabled:"
		elog "systemctl --user disable pulseaudio.service pulseaudio.socket"
		elog "systemctl --user enable pipewire.socket pipewire-pulse.socket"
		elog "Rebooting is strongly recommended to avoid surprises from"
		elog "remnant PulseAudio daemon auto-spawning and surviving logouts."
		elog
		ewarn "Both new users and those upgrading need to enable pipewire-media-session:"
		ewarn "systemctl --user enable pipewire-media-session.service"
		ewarn "People using it for screencasting still need only pipewire.socket enabled."
	else
		elog "This ebuild auto-enables PulseAudio replacement. Because of that users"
		elog "are recommended to edit: ${EROOT}/etc/pulse/client.conf and disable"
		elog "autospawn'ing of the original daemon by setting:"
		elog "autospawn = no"
		elog "Please note that the semicolon (;) must _NOT_ be at the beginning of the line!"
		elog
		elog "Alternatively, if replacing PulseAudio daemon is not desired, edit"
		elog "${EROOT}/etc/pipewire/pipewire.conf"
		elog "by commenting out the relevant command near the end of the file:"
		elog "#\"/usr/bin/pipewire\" = { args = \"-c pipewire-pulse.conf\" }"
		elog
		ewarn "${EROOT}/etc/xdg/autostart/pipewire.desktop has been installed. Users of XDG"
		ewarn "compliant desktops on OpenRC must not manually start pipewire anymore!"
	fi

	optfeature_header "The following can be installed for optional runtime features:"
	optfeature "restricted realtime capabilities vai D-Bus" sys-auth/rtkit
	# Once hsphfpd lands in tree, both it and ofono will need to be checked for presence here!
	if use bluetooth; then
		optfeature "better BT headset support (daemon startup required)" net-misc/ofono
		#optfeature "an oFono alternative (not packaged)" foo-bar/hsphfpd
	fi
}
