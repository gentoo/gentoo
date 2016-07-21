# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"
[[ "${PV}" = "2.9999" ]] && inherit git-r3
inherit eutils python-single-r1 waf-utils multilib-minimal

DESCRIPTION="Jackdmp jack implemention for multi-processor machine"
HOMEPAGE="http://jackaudio.org/"

RESTRICT="mirror"
if [[ "${PV}" = "2.9999" ]]; then
	EGIT_REPO_URI="git://github.com/jackaudio/jack2.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/jackaudio/jack2/archive/v${PV}.tar.gz -> jack2-${PV}.tar.gz"
	KEYWORDS="~amd64 ~ppc ~x86"
fi

LICENSE="GPL-2"
SLOT="2"
IUSE="alsa celt dbus doc opus pam"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# FIXME: automagic deps: readline, samplerate, sndfile, celt, opus
# FIXME: even though sndfile is just used for binaries, the check is flawed
#	making the build fail if multilib libsndfile is not found.
CDEPEND="media-libs/libsamplerate[${MULTILIB_USEDEP}]
	media-libs/libsndfile[${MULTILIB_USEDEP}]
	sys-libs/readline:0
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

[[ "${PV}" = "2.9999" ]] || S="${WORKDIR}/jack2-${PV}"

DOCS=( ChangeLog README README_NETJACK2 TODO )

src_unpack() {
	if [[ "${PV}" = "2.9999" ]]; then
		git-r3_src_unpack
	else
		default
	fi
}

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	local mywafconfargs=(
		$(usex alsa --alsa "")
		$(usex dbus --dbus --classic)
	)

	WAF_BINARY="${BUILD_DIR}"/waf waf-utils_src_configure ${mywafconfargs[@]}
}

multilib_src_compile() {
	WAF_BINARY="${BUILD_DIR}"/waf waf-utils_src_compile

	if multilib_is_native_abi && use doc; then
		doxygen || die "doxygen failed"
	fi
}

multilib_src_install() {
	multilib_is_native_abi && use doc && \
		HTML_DOCS=( "${BUILD_DIR}"/html/ )
	WAF_BINARY="${BUILD_DIR}"/waf waf-utils_src_install
}

multilib_src_install_all() {
	python_fix_shebang "${ED}"
}
