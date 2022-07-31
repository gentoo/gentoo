# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic multilib-minimal

DESCRIPTION="ALSA extra plugins"
HOMEPAGE="https://alsa-project.org/wiki/Main_Page"
SRC_URI="https://www.alsa-project.org/files/pub/plugins/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv sparc x86 ~amd64-linux"
IUSE="arcam_av debug ffmpeg jack libsamplerate +mix oss pulseaudio speex +usb_stream"

RDEPEND="
	>=media-libs/alsa-lib-${PV}:=[${MULTILIB_USEDEP}]
	ffmpeg? ( media-video/ffmpeg:0=[${MULTILIB_USEDEP}] )
	jack? ( virtual/jack[${MULTILIB_USEDEP}] )
	libsamplerate? ( >=media-libs/libsamplerate-0.1.8-r1:=[${MULTILIB_USEDEP}] )
	pulseaudio? ( media-libs/libpulse[${MULTILIB_USEDEP}] )
	speex? (
		>=media-libs/speex-1.2.0:=[${MULTILIB_USEDEP}]
		media-libs/speexdsp[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	# For some reasons the polyp/pulse plugin does fail with alsaplayer with a
	# failed assert. As the code works just fine with asserts disabled, for now
	# disable them waiting for a better solution.
	sed \
		-e '/AM_CFLAGS/s:-Wall:-DNDEBUG -Wall:' \
		-i pulse/Makefile.am || die

	eautoreconf
}

multilib_src_configure() {
	use debug || append-cppflags -DNDEBUG

	local myeconfargs=(
		# default does not contain $prefix: bug #673464
		--with-alsalconfdir="${EPREFIX}"/etc/alsa/conf.d

		--with-speex="$(usex speex lib no)"
		$(use_enable arcam_av arcamav)
		$(use_enable ffmpeg libav)
		$(use_enable jack)
		$(use_enable libsamplerate samplerate)
		$(use_enable mix)
		$(use_enable oss)
		$(use_enable pulseaudio)
		$(use_enable speex speexdsp)
		$(use_enable usb_stream usbstream)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install() {
	# Needed to workaround parallel build failure
	# bug #835920
	dodir /usr/$(get_libdir)/alsa-lib

	default
}

multilib_src_install_all() {
	einstalldocs

	cd doc || die
	dodoc upmix.txt vdownmix.txt README-pcm-oss
	use jack && dodoc README-jack
	use libsamplerate && dodoc samplerate.txt
	use ffmpeg && dodoc lavrate.txt a52.txt

	if use pulseaudio; then
		dodoc README-pulse
		# install ALSA configuration files
		# making PA to be used by alsa clients
		insinto /usr/share/alsa
		doins "${FILESDIR}"/pulse-default.conf

		insinto /usr/share/alsa/alsa.conf.d
		doins "${FILESDIR}"/51-pulseaudio-probe.conf
		# bug #670960
		dosym ../../../usr/share/alsa/alsa.conf.d/51-pulseaudio-probe.conf \
			/etc/alsa/conf.d/51-pulseaudio-probe.conf
	fi

	find "${ED}" -type f \( -name '*.a' -o -name '*.la' \) -delete || die
}

pkg_postinst() {
	if use pulseaudio; then
		einfo "The PulseAudio device is now set as the default device if the"
		einfo "PulseAudio server is found to be running. Any custom"
		einfo "configuration in /etc/asound.conf or ~/.asoundrc for this"
		einfo "purpose should now be unnecessary."
	fi
}
