# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils fdo-mime mono-env versionator gnome2

DESCRIPTION="Import, play and share your music using a simple and powerful interface"
HOMEPAGE="http://banshee.fm/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+aac +cdda +bpm daap doc +encode ipod karma mtp test udev youtube"

RDEPEND="
	>=dev-lang/mono-2.4.3
	<dev-lang/mono-4
	dev-libs/glib:2[dbus]
	gnome-base/gnome-settings-daemon
	sys-apps/dbus
	>=dev-dotnet/gtk-sharp-2.12:2
	>=dev-dotnet/notify-sharp-0.4.0_pre20080912-r1
	>=media-libs/gstreamer-0.10.21-r3:0.10
	>=media-libs/gst-plugins-base-0.10.25.2:0.10
	media-libs/gst-plugins-bad:0.10
	media-libs/gst-plugins-good:0.10
	media-libs/gst-plugins-ugly:0.10
	>=media-plugins/gst-plugins-meta-0.10-r2:0.10
	media-plugins/gst-plugins-gio:0.10
	>=dev-dotnet/gconf-sharp-2.24.0:2
	media-plugins/gst-plugins-gconf:0.10
	cdda? (
		|| (
			media-plugins/gst-plugins-cdparanoia:0.10
			media-plugins/gst-plugins-cdio:0.10
		)
	)
	media-libs/musicbrainz:3
	dev-dotnet/dbus-sharp:1.0
	dev-dotnet/dbus-sharp-glib:1.0
	>=dev-dotnet/mono-addins-0.6.2[gtk]
	>=dev-dotnet/taglib-sharp-2.0.3.7
	>=dev-db/sqlite-3.4:3
	karma? ( >=media-libs/libkarma-0.1.0-r1 )
	aac? ( media-plugins/gst-plugins-faad:0.10 )
	bpm? ( media-plugins/gst-plugins-soundtouch:0.10 )
	daap? (	>=dev-dotnet/mono-zeroconf-0.8.0-r1 )
	doc? ( >=app-text/gnome-doc-utils-0.17.3 )
	encode? (
		media-plugins/gst-plugins-lame:0.10
		media-plugins/gst-plugins-taglib:0.10
	)
	ipod? ( >=media-libs/libgpod-0.8.2[mono] )
	mtp? ( >=media-libs/libmtp-0.3.0:= )
	youtube? ( >=dev-dotnet/google-gdata-sharp-1.4 )
	udev? (
		app-misc/media-player-info
		dev-dotnet/gudev-sharp
		dev-dotnet/gkeyfile-sharp
		dev-dotnet/gtk-sharp-beans
		dev-dotnet/gio-sharp
	)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare () {
	# Don't build BPM extension when not wanted
	if ! use bpm; then
		sed -i -e 's:Banshee.Bpm:$(NULL):g' src/Extensions/Makefile.am || die
	fi

	# Don't append -ggdb, bug #458632, upstream bug #698217
	sed -i -e 's:-ggdb3:$(NULL):g' libbanshee/Makefile.am || die
	sed -i -e 's:-ggdb3::g' src/Core/Banshee.WebBrowser/libossifer/Makefile.am || die

	AT_M4DIR="-I build/m4/banshee -I build/m4/shamrock -I build/m4/shave" \
	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	# soundmenu needs a properly maintained and updated indicate-sharp
	# webkit disabled due to bug #584178
	local myconf="
		--disable-static
		--enable-gnome
		--enable-schemas-install
		--with-gconf-schema-file-dir=/etc/gconf/schemas
		--with-vendor-build-id=Gentoo/${PN}/${PVR}
		--enable-gapless-playback
		--disable-boo
		--disable-gst-sharp
		--disable-torrent
		--disable-shave
		--disable-ubuntuone
		--disable-soundmenu
		--disable-upnp
		--disable-webkit"

	gnome2_src_configure \
		$(use_enable doc docs) \
		$(use_enable doc user-help) \
		$(use_enable mtp) \
		$(use_enable daap) \
		$(use_enable ipod appledevice) \
		$(use_enable karma) \
		$(use_enable youtube) \
		$(use_enable udev gio) \
		$(use_enable udev gio_hardware) \
		${myconf}
}

src_compile() {
	gnome2_src_compile MCS=/usr/bin/gmcs
}
