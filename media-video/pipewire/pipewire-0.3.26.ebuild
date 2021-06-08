# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson optfeature udev

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/${PN}/${PN}.git"
#	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://gitlab.freedesktop.org/${PN}/${PN}/-/archive/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
fi

DESCRIPTION="Multimedia processing graphs"
HOMEPAGE="https://pipewire.org/"

LICENSE="LGPL-2.1+"
SLOT="0/0.3"
IUSE="aac aptx bluetooth doc extra gstreamer jack-client ldac pipewire-alsa systemd test v4l"

# Once replacing system JACK libraries is possible, it's likely that
# jack-client IUSE will need blocking to avoid users accidentally
# configuring their systems to send PW sink output to the emulated
# JACK's sink - doing so is likely to yield no audio, cause a CPU
# cycles consuming loop (and may even cause GUI crashes)!

REQUIRED_USE="
	aac? ( bluetooth )
	aptx? ( bluetooth )
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
	sys-apps/dbus
	sys-libs/ncurses[unicode]
	virtual/libudev
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
	pipewire-alsa? (
		>=media-libs/alsa-lib-1.1.7
		|| (
			media-plugins/alsa-plugins[-pulseaudio]
			!media-plugins/alsa-plugins
		)
	)
	!pipewire-alsa? ( media-plugins/alsa-plugins[pulseaudio] )
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

DOCS=( {README,INSTALL}.md NEWS )

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.3.25-enable-failed-mlock-warning.patch
)

# limitsdfile related code taken from =sys-auth/realtime-base-0.1
# with changes as necessary.
limitsdfile=40-${PN}.conf

src_prepare() {
	default

	if ! use systemd; then
		# This can be applied non-conditionally but would make for a
		# significantly worse user experience on systemd then.
		eapply "${FILESDIR}"/${PN}-0.3.25-non-systemd-integration.patch
	fi
}

src_configure() {
	local emesonargs=(
		-Ddocdir="${EPREFIX}"/usr/share/doc/${PF}
		$(meson_feature doc docs)
		-Dexamples=enabled # Disabling this implicitly disables -Dmedia-session (not good)
		-Dmedia-session=enabled
		-Dman=enabled
		$(meson_feature test tests)
		-Dinstalled_tests=disabled # Matches upstream; Gentoo never installs tests
		$(meson_feature gstreamer)
		$(meson_feature gstreamer gstreamer-device-provider)
		$(meson_feature systemd) # Also covers logind integration
		-Dsystemd-system-service=disabled # Matches upstream
		$(meson_feature systemd systemd-user-service)
		$(meson_feature pipewire-alsa) # Allows integrating ALSA apps into PW graph
		-Dpipewire-jack=enabled # Allows integrating JACK apps into PW graph
		#-Dlibjack-path="" # Where to install libjack.so et al (if an absolute path is used, remember to prefix it with ${EROOT} or similar!); setting this will also break pw-jack's multilib support (but presumably that's okay as the intended use would be to replace system's libraries making the loader irrelevant)
		-Dspa-plugins=enabled
		-Dalsa=enabled # Allows using kernel ALSA for sound I/O (-Dmedia-session depends on this)
		-Daudiomixer=enabled # Matches upstream
		-Daudioconvert=enabled # Matches upstream
		$(meson_feature bluetooth bluez5)
		$(meson_feature bluetooth bluez5-backend-hsp-native)
		$(meson_feature bluetooth bluez5-backend-hfp-native)
		$(meson_feature bluetooth bluez5-backend-ofono)
		$(meson_feature bluetooth bluez5-backend-hsphfpd)
		$(meson_feature aac bluez5-codec-aac)
		$(meson_feature aptx bluez5-codec-aptx)
		$(meson_feature ldac bluez5-codec-ldac)
		-Dcontrol=enabled # Matches upstream
		-Daudiotestsrc=enabled # Matches upstream
		-Dffmpeg=disabled # Disabled by upstream and no major developments to spa/plugins/ffmpeg/ since May 2020
		$(meson_feature jack-client jack) # Allows PW to act as a JACK client
		-Dsupport=enabled # Miscellaneous/common plugins, such as null sink
		-Devl=disabled # Matches upstream
		-Dtest=disabled # fakesink and fakesource plugins
		$(meson_feature v4l v4l2)
		-Dlibcamera=disabled # libcamera is not in Portage tree
		-Dvideoconvert=enabled # Matches upstream
		-Dvideotestsrc=enabled # Matches upstream
		-Dvolume=enabled # Matches upstream
		-Dvulkan=disabled # Uses pre-compiled Vulkan compute shader to provide a CGI video source (dev thing; disabled by upstream)
		$(meson_feature extra pw-cat)
		-Dudev=enabled
		-Dudevrulesdir="$(get_udevdir)/rules.d"
		-Dsdl2=disabled # Controls SDL2 dependent code (currently only examples when -Dinstalled_tests=enabled which we never install)
		$(meson_feature extra sndfile) # Enables libsndfile dependent code (currently only pw-cat)
	)
	meson_src_configure
}

src_compile() {
	meson_src_compile

	einfo "Generating ${limitsdfile}"
	cat > ${limitsdfile} <<- EOF || die
		# Start of ${limitsdfile} from ${P}

		1000:60000	-	memlock 256

		# End of ${limitsdfile} from ${P}
	EOF
}

src_install() {
	meson_src_install

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
}

pkg_postinst() {
	if ! use pipewire-alsa; then
		elog "Contrary to what some online resources may suggest, avoid setting"
		elog "PULSE_LATENCY_MSEC environment variable since it may break ALSA clients."
		elog
	fi

	elog "JACK emulation is incomplete and not all programs will work. PipeWire's"
	elog "alternative libraries have been installed to a non-default location."
	elog "To use them, put pw-jack <application> before every JACK application."
	elog "When using pw-jack, do not run jackd/jackdbus. However, a virtual/jack"
	elog "provider is still needed to compile the JACK applications themselves."
	elog

	if use systemd; then
		elog "Per Gentoo policy installed systemd units must be manually enabled:"
		elog "systemctl --user disable pulseaudio.service pulseaudio.socket"
		elog "systemctl --user enable pipewire.socket pipewire-pulse.socket"
		elog "Rebooting is strongly recommended to avoid surprises from"
		elog "remnant PulseAudio daemon auto-spawning and surviving logouts."
		elog
		ewarn "Both new users and those upgrading need to enable pipewire-media-session:"
		ewarn "systemctl --user enable pipewire-media-session.service"
	else
		elog "This ebuild auto-enables PulseAudio replacement. Because of that users"
		elog "are recommended to edit: ${EROOT}/etc/pulse/client.conf and disable "
		elog "autospawn'ing of the original daemon by setting:"
		elog "autospawn = no"
		elog "Please note that the semicolon (;) must _NOT_ be at the beginning of the line!"
		elog
		elog "Alternatively, if replacing PulseAudio daemon is not desired, edit"
		elog "${EROOT}/etc/pipewire/pipewire.conf"
		elog "by commenting out the relevant command near the end of the file:"
		elog "#\"/usr/bin/pipewire\" = { args = \"-c pipewire-pulse.conf\" }"
		elog
		elog "It is still necessary to manually enable PipeWire startup. Setup specific"
		elog "instructions can be found at: https://wiki.gentoo.org/wiki/PipeWire"
	fi

	optfeature_header "The following can be installed for optional runtime features:"
	optfeature "restricted realtime capabilities vai D-Bus" sys-auth/rtkit
	# Once hsphfpd lands in tree, both it and ofono will need to be checked for presence here!
	if use bluetooth; then
		optfeature "better BT headset support (daemon startup required)" net-misc/ofono
		#optfeature "an oFono alternative (not packaged)" foo-bar/hsphfpd
	fi
}
