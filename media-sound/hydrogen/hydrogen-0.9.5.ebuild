# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils multilib flag-o-matic toolchain-funcs

DESCRIPTION="Advanced drum machine"
HOMEPAGE="http://www.hydrogen-music.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2 ZLIB"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="alsa +archive jack ladspa lash oss portaudio"

RDEPEND="dev-qt/qtgui:4 dev-qt/qtcore:4
	archive? ( app-arch/libarchive )
	!archive? ( >=dev-libs/libtar-1.2.11-r3 )
	>=media-libs/libsndfile-1.0.18
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	ladspa? ( media-libs/liblrdf )
	lash? ( media-sound/lash )
	portaudio? ( >=media-libs/portaudio-19_pre )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/scons"

src_prepare() {
	sed -i -e '/cppflags +=/d' Sconstruct || die
	epatch \
		patches/portaudio.patch \
		"${FILESDIR}"/${P}-use_lrdf_pkgconfig.patch \
		"${FILESDIR}"/${P}-gcc47.patch
}

src_compile() {
	# FIXME: The -I/usr/include/raptor2 gets lost in middle of build
	# despite -use_lrdf_pkgconfig.patch
	use ladspa && append-flags $($(tc-getPKG_CONFIG) --cflags lrdf)

	export QTDIR="/usr/$(get_libdir)"
	local myconf='portmidi=0' #90614

	use alsa || myconf+=' alsa=0'
	use archive && myconf+=' libarchive=1'
	use jack || myconf+=' jack=0'
	use ladspa || myconf+=' lrdf=0'
	use lash && myconf+=' lash=1'
	use oss || myconf+=' oss=0'
	use portaudio && myconf+=' portaudio=1'

	scons \
		prefix=/usr \
		DESTDIR="${D}" \
		optflags="${CXXFLAGS}" \
		${myconf} || die
}

src_install() {
	dobin hydrogen
	insinto /usr/share/hydrogen
	doins -r data
	doicon data/img/gray/h2-icon.svg
	domenu hydrogen.desktop
	dosym /usr/share/hydrogen/data/doc /usr/share/doc/${PF}/html
	dodoc AUTHORS ChangeLog README.txt
}
