# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib toolchain-funcs

DESCRIPTION="Homer Conferencing (short: Homer) is a free SIP softphone with advanced audio and video support"
HOMEPAGE="http://www.homer-conferencing.com"

MY_PN="Homer-Conferencing"
MY_BIN="Homer"

if [[ ${PV} == *9999* ]]; then
	inherit git-2
	EGIT_REPO_URI="git://github.com/${MY_PN}/${MY_PN}.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/V${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=">=dev-libs/openssl-1.0
	media-libs/alsa-lib
	media-libs/libsdl[X,sound,video,alsa]
	media-libs/portaudio[alsa]
	media-libs/sdl-mixer
	media-libs/sdl-sound
	media-libs/x264:*
	net-libs/sofia-sip
	virtual/ffmpeg:0[X]
	|| ( <media-video/ffmpeg-2 media-video/libav )
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtmultimedia:4
	dev-qt/qtwebkit:4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	epatch "${FILESDIR}/${P}-libav-9.patch"
}

src_compile() {
	tc-export CXX
	emake -C HomerBuild default \
		INSTALL_PREFIX=/usr/bin \
		INSTALL_LIBDIR=/usr/$(get_libdir) \
		INSTALL_DATADIR=/usr/share/${PN} \
		VERBOSE=1
}

src_install() {
	emake -C HomerBuild install \
		DESTDIR="${D}" \
		VERBOSE=1

	# Create .desktop entry
	doicon ${MY_BIN}/${MY_BIN}.png
	make_desktop_entry "${MY_BIN}" "${MY_PN}" "${MY_BIN}" "Network;InstantMessaging;Telephony;VideoConference"
}
