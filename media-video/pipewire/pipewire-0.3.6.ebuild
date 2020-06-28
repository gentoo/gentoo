# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/PipeWire/pipewire.git"
	EGIT_BRANCH="work"
	inherit git-r3
else
	SRC_URI="https://github.com/PipeWire/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc64 ~x86"
fi

DESCRIPTION="Multimedia processing graphs"
HOMEPAGE="https://pipewire.org/"

LICENSE="LGPL-2.1+"
SLOT="0/0.3"
IUSE="+alsa bluetooth debug doc ffmpeg gstreamer jack pulseaudio systemd test vulkan X"

BDEPEND="
	app-doc/xmltoman
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)
"
RDEPEND="
	media-libs/alsa-lib
	media-libs/libsdl2
	media-libs/libsndfile
	sys-apps/dbus
	virtual/libudev
	bluetooth? (
		media-libs/sbc
		net-wireless/bluez:=
	)
	ffmpeg? ( media-video/ffmpeg:= )
	gstreamer? (
		dev-libs/glib:2
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	jack? ( >=media-sound/jack2-1.9.10:2 )
	pulseaudio? (
		dev-libs/glib:2
		media-sound/pulseaudio
	)
	systemd? ( sys-apps/systemd )
	vulkan? ( media-libs/vulkan-loader )
	X? ( x11-libs/libX11 )
"
DEPEND="${RDEPEND}
	vulkan? ( dev-util/vulkan-headers )
"

DOCS=( {README,INSTALL}.md NEWS )

RESTRICT="!test? ( test )"

src_prepare() {
	spa_use() {
		if ! in_iuse ${1} || ! use ${1}; then
			sed -e "/^add-spa-lib.*${1}/s/^/#${2-$1}-disabled-by-USE-no-${1}\:/" \
				-e "/^load-module.*${1}/s/^/#${2-$1}-disabled-by-USE-no-${1}\:/" \
				-i src/daemon/pipewire.conf.in || die
		fi
	}

	default
	spa_use libcamera
	spa_use rtkit
	spa_use bluetooth bluez5
	spa_use jack
	spa_use vulkan
}

src_configure() {
	local emesonargs=(
		-Dexamples=true # contains required pipewire-media-session
		-Dman=true
		-Dspa=true
		-Dspa-plugins=true
		--buildtype=$(usex debug debugoptimized plain)
		# alsa plugin and jack/pulseaudio emulation
		$(meson_use alsa pipewire-alsa)
		$(meson_use jack pipewire-jack)
		$(meson_use pulseaudio pipewire-pulseaudio)
		# spa-plugins
		# we install alsa support unconditionally
		$(meson_use bluetooth bluez5)
		$(meson_use ffmpeg)
		$(meson_use jack)
		$(meson_use vulkan)
		# libcamera is not packaged
		# misc
		$(meson_use doc docs)
		$(meson_use gstreamer)
		$(meson_use systemd)
		$(meson_use test test)
		$(meson_use test tests)
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	dosym ../../../usr/share/alsa/alsa.conf.d/50-pipewire.conf /etc/alsa/conf.d/50-pipewire.conf

	if use alsa; then
		dosym ../../../usr/share/alsa/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d/99-pipewire-default.conf
	fi
}

pkg_postinst() {
	elog "Package has optional sys-auth/rtkit RUNTIME support that may be disabled"
	elog "by setting DISABLE_RTKIT env var."
	elog "To enable rtkit, uncomment the load-module line in /etc/pipewire/pipewire.conf"
	elog
	if use jack; then
		elog "Please note that even though the libraries for JACK emulation have"
		elog "been installed, this ebuild is not yet wired up to replace a JACK server."
		elog
	fi
	if use pulseaudio; then
		elog "Please note that even though the libraries for PulseAudio emulation have"
		elog "been installed, this ebuild is not yet wired up to replace PulseAudio."
		elog
	fi
	elog "Read INSTALL.md for information about ALSA plugin or JACK/PulseAudio emulation."
}
