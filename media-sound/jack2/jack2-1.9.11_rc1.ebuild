# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"
inherit eutils python-single-r1 waf-utils multilib-minimal

DESCRIPTION="Jackdmp jack implemention for multi-processor machine"
HOMEPAGE="http://jackaudio.org/"

if [[ "${PV}" = "2.9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/jackaudio/jack2.git"
	KEYWORDS=""
else
	MY_PV="${PV/_rc/-RC}"
	MY_P="${PN}-${MY_PV}"
	S="${WORKDIR}/${MY_P}"
	SRC_URI="https://github.com/jackaudio/jack2/archive/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~ppc ~x86"
fi

LICENSE="GPL-2"
SLOT="2"
IUSE="alsa celt dbus doc opus pam classic sndfile libsamplerate readline"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

CDEPEND="media-libs/libsamplerate
	media-libs/libsndfile
	sys-libs/readline:0=
	${PYTHON_DEPS}
	alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )
	celt? ( media-libs/celt:0[${MULTILIB_USEDEP}] )
	dbus? (
		dev-libs/expat[${MULTILIB_USEDEP}]
		sys-apps/dbus[${MULTILIB_USEDEP}]
	)
	opus? ( media-libs/opus[custom-modes,${MULTILIB_USEDEP}] )"
DEPEND="!media-sound/jack-audio-connection-kit:0
	${CDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"
RDEPEND="${CDEPEND}
	dbus? ( dev-python/dbus-python[${PYTHON_USEDEP}] )
	pam? ( sys-auth/realtime-base )"

DOCS=( ChangeLog README README_NETJACK2 TODO )

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	local mywafconfargs=(
		--htmldir=/usr/share/doc/${PF}/html
		$(usex dbus --dbus "")
		$(usex classic --classic "")
		--alsa=$(usex alsa yes no)
		--celt=$(usex celt yes no)
		--doxygen=$(multilib_native_usex doc yes no)
		--firewire=no
		--freebob=no
		--iio=no
		--opus=$(usex opus yes no)
		--portaudio=no
		--readline=$(multilib_native_usex readline yes no)
		--samplerate=$(multilib_native_usex libsamplerate yes no)
		--sndfile=$(multilib_native_usex sndfile yes no)
		--winmme=no
	)

	waf-utils_src_configure ${mywafconfargs[@]}
}

multilib_src_compile() {
	WAF_BINARY="${BUILD_DIR}"/waf waf-utils_src_compile
}

multilib_src_install() {
	WAF_BINARY="${BUILD_DIR}"/waf waf-utils_src_install
}

multilib_src_install_all() {
	python_fix_shebang "${ED}"
}
