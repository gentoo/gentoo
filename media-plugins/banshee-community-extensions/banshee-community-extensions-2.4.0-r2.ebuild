# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit base mono

DESCRIPTION="Community-developed plugins for the Banshee media player"
HOMEPAGE="http://banshee.fm/download/extensions/"
SRC_URI="http://download.banshee-project.org/${PN}/${PV}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc lastfmfingerprint lirc mirage telepathy zeitgeist"

DEPEND=">=dev-lang/mono-2.0
	>=media-sound/banshee-2.4.0
	>=gnome-base/gconf-2.0
	dev-dotnet/gconf-sharp:2
	doc? ( >=app-text/gnome-doc-utils-0.17.3 )
	lastfmfingerprint? (
		sci-libs/fftw:3.0
		media-libs/libsamplerate
	)
	lirc? ( app-misc/lirc  )
	mirage? (
		dev-libs/glib:2
		dev-db/sqlite:3
		sci-libs/fftw:3.0
		media-libs/libsamplerate
		>=media-libs/gstreamer-0.10.15:0.10
		>=media-libs/gst-plugins-base-0.10.15:0.10
	)
	telepathy? (
		dev-dotnet/notify-sharp
		>=dev-lang/mono-2.4.2
	)
	zeitgeist? (
		dev-libs/libzeitgeist
		dev-dotnet/zeitgeist-sharp
	)"
RDEPEND="${DEPEND}
	!media-plugins/banshee-mirage"

DOCS=( AUTHORS NEWS README )

src_configure() {
	# Disable ClutterFlow as we don't have clutter-sharp and co in tree
	# Disable UbuntuOneMusicStore as we don't have ubuntuone-sharp
	# Disable AppIndicator as it's not in tree
	# Disable OpenVP as some of its dependencies are not in the tree
	# Disable SoundMenu as it requires indicate-sharp
	# Disable zeitgeistdataprovider as it requires zeitgeist-sharp
	# Disable Lyrics, Karaoke & Jamendo as they require banshee[web]
	local myconf="--enable-gnome
		--disable-static
		--enable-release
		--disable-maintainer-mode
		--with-gconf-schema-file-dir=/etc/gconf/schemas
		--with-vendor-build-id=Gentoo/${PN}/${PVR}
		--disable-scrollkeeper
		--disable-clutterflow --disable-appindicator --disable-openvp
		--enable-ampache --disable-karaoke --disable-jamendo
		--enable-randombylastfm --enable-albumartwriter
		--enable-duplicatesongdetector --enable-foldersync
		--disable-lyrics"

	econf \
		$(use_enable doc user-help) \
		$(use_enable lastfmfingerprint) \
		$(use_enable lirc) \
		$(use_enable mirage) \
		$(use_enable telepathy) \
		$(use_enable zeitgeist zeitgeistdataprovider) \
		$(use_enable test tests) \
		${myconf}
}

src_install() {
	base_src_install
	prune_libtool_files --all
}
