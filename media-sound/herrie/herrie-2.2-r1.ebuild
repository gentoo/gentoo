# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils toolchain-funcs

DESCRIPTION="Herrie is a command line music player"
HOMEPAGE="http://herrie.info/"
SRC_URI="http://herrie.info/distfiles/${P}.tar.bz2"

LICENSE="BSD-2 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="ao +alsa pulseaudio oss http modplug mp3 sndfile vorbis xspf unicode nls"
APP_LINGUAS="ca da de es fi ga nl pl pt_BR ru sv tr vi zh_CN"
for X in ${APP_LINGUAS}; do
	IUSE="${IUSE} linguas_${X}"
done
REQUIRED_USE="|| ( ao alsa pulseaudio oss )"

RDEPEND="sys-libs/ncurses:0=[unicode?]
	>=dev-libs/glib-2:2
	ao? ( media-libs/libao )
	alsa? ( media-libs/alsa-lib )
	http? ( net-misc/curl )
	modplug? ( media-libs/libmodplug )
	mp3? ( media-libs/libmad
		media-libs/libid3tag )
	pulseaudio? ( media-sound/pulseaudio )
	sndfile? ( media-libs/libsndfile )
	vorbis? ( media-libs/libvorbis )
	xspf? ( >=media-libs/libxspf-1.2 )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-chost_issue.patch"
	"${FILESDIR}/${P}-libxspf.patch"
	"${FILESDIR}/${P}-fix-buildsystem.patch"
)

src_configure() {
	local EXTRA_CONF="verbose no_strip"
	use ao && EXTRA_CONF="${EXTRA_CONF} ao"
	use alsa && EXTRA_CONF="${EXTRA_CONF} alsa"
	use http || EXTRA_CONF="${EXTRA_CONF} no_http no_scrobbler"
	use mp3 || EXTRA_CONF="${EXTRA_CONF} no_mp3"
	use modplug || EXTRA_CONF="${EXTRA_CONF} no_modplug"
	use nls || EXTRA_CONF="${EXTRA_CONF} no_nls"
	use oss && EXTRA_CONF="${EXTRA_CONF} oss"
	use pulseaudio && EXTRA_CONF="${EXTRA_CONF} pulse"
	use sndfile || EXTRA_CONF="${EXTRA_CONF} no_sndfile"
	use unicode || EXTRA_CONF="${EXTRA_CONF} ncurses"
	use vorbis || EXTRA_CONF="${EXTRA_CONF} no_vorbis"
	use xspf || EXTRA_CONF="${EXTRA_CONF} no_xspf"

	einfo "./configure ${EXTRA_CONF}"
	CC="$(tc-getCC)" PREFIX=/usr MANDIR=/usr/share/man \
		./configure ${EXTRA_CONF} || die "configure failed"
}
