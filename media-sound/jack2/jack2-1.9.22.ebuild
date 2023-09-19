# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="threads(+)"
inherit flag-o-matic python-single-r1 waf-utils multilib-minimal

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jackaudio/${PN}.git"
else
	SRC_URI="https://github.com/jackaudio/jack2/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv x86"
fi

DESCRIPTION="Jackdmp jack implemention for multi-processor machine"
HOMEPAGE="https://jackaudio.org/"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="2"
IUSE="+alsa +classic dbus doc ieee1394 libsamplerate metadata opus pam +tools systemd"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	|| ( classic dbus )"

DEPEND="
	alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )
	dbus? (
		dev-libs/expat[${MULTILIB_USEDEP}]
		sys-apps/dbus[${MULTILIB_USEDEP}]
	)
	libsamplerate? ( media-libs/libsamplerate[${MULTILIB_USEDEP}] )
	ieee1394? ( media-libs/libffado[${MULTILIB_USEDEP}] )
	metadata? ( sys-libs/db:=[${MULTILIB_USEDEP}] )
	opus? ( media-libs/opus[custom-modes,${MULTILIB_USEDEP}] )
	systemd? ( classic? ( sys-apps/systemd:= ) )"
RDEPEND="
	${DEPEND}
	dbus? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/dbus-python[${PYTHON_USEDEP}]
		')
	)
	pam? ( sys-auth/realtime-base )
	!media-sound/jack-audio-connection-kit
	!media-video/pipewire[jack-sdk(-)]"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"
# tools were formerly provided here, pull to maintain expectations
PDEPEND="tools? ( media-sound/jack-example-tools )"

DOCS=( AUTHORS.rst ChangeLog.rst README.rst README_NETJACK2 )

src_prepare() {
	default

	python_fix_shebang waf
	multilib_copy_sources
}

multilib_src_configure() {
	# clients crash if built with lto
	# https://github.com/jackaudio/jack2/issues/485
	filter-lto

	local wafargs=(
		--mandir="${EPREFIX}"/usr/share/man/man1 # override eclass' for man1

		--alsa=$(usex alsa)
		--celt=no
		$(usev classic --classic)
		--db=$(usex metadata)
		$(usev dbus --dbus)
		--doxygen=$(multilib_native_usex doc)
		--firewire=$(usex ieee1394)
		--iio=no
		--opus=$(usex opus)
		--portaudio=no
		--samplerate=$(usex libsamplerate)
		--systemd=$(multilib_native_usex systemd $(usex classic))
		--winmme=no
	)

	waf-utils_src_configure "${wafargs[@]}"
}

multilib_src_compile() {
	waf-utils_src_compile
}

multilib_src_install() {
	waf-utils_src_install
}

multilib_src_install_all() {
	use dbus && python_fix_shebang "${ED}"/usr/bin/jack_control
}
