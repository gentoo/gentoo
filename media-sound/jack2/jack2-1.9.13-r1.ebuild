# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 python3_7 )
PYTHON_REQ_USE="threads(+)"
inherit python-single-r1 waf-utils multilib-minimal

DESCRIPTION="Jackdmp jack implemention for multi-processor machine"
HOMEPAGE="http://jackaudio.org/"

if [[ "${PV}" = "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jackaudio/${PN}.git"
else
	MY_PV="${PV/_rc/-RC}"
	MY_P="${PN}-${MY_PV}"
	S="${WORKDIR}/${MY_P}"
	SRC_URI="https://github.com/jackaudio/jack2/releases/download/v${MY_PV}/${MY_P}.tar.gz"
	KEYWORDS="amd64 ~ppc x86"
fi

LICENSE="GPL-2"
SLOT="2"
IUSE="alsa +classic dbus doc ieee1394 libsamplerate metadata opus pam readline sndfile"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	|| ( classic dbus )"

CDEPEND="${PYTHON_DEPS}
	media-libs/libsamplerate
	media-libs/libsndfile
	sys-libs/readline:0=
	alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )
	dbus? (
		dev-libs/expat[${MULTILIB_USEDEP}]
		sys-apps/dbus[${MULTILIB_USEDEP}]
	)
	ieee1394? ( media-libs/libffado:=[${MULTILIB_USEDEP}] )
	metadata? ( sys-libs/db:* )
	opus? ( media-libs/opus[custom-modes,${MULTILIB_USEDEP}] )"
DEPEND="${CDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"
RDEPEND="${CDEPEND}
	dbus? ( dev-python/dbus-python[${PYTHON_USEDEP}] )
	pam? ( sys-auth/realtime-base )
	!media-sound/jack-audio-connection-kit:0"

DOCS=( ChangeLog.rst README.rst README_NETJACK2 )

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
		--celt=no
		--db=$(usex metadata yes no)
		--doxygen=$(multilib_native_usex doc yes no)
		--firewire=$(usex ieee1394 yes no)
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
