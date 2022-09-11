# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P=${PN}-src-${PV}
inherit autotools qmake-utils toolchain-funcs

DESCRIPTION="Simple Qt5 or GTK+3 interface for capturing and viewing video from v4l2 devices"
HOMEPAGE="http://guvcview.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gsl pulseaudio qt5"

BDEPEND="
	dev-util/intltool
	sys-devel/autoconf-archive
	sys-devel/gettext
	virtual/pkgconfig
"
RDEPEND="
	>=dev-libs/glib-2.10
	media-libs/libpng:0=
	media-libs/libsdl2
	media-libs/libv4l
	>=media-libs/portaudio-19_pre
	>=media-video/ffmpeg-2.8:0=
	virtual/libusb:1
	virtual/udev
	gsl? ( >=sci-libs/gsl-1.15:= )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.15 )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
	!qt5? ( >=x11-libs/gtk+-3.6:3 )
"
# linux-headers: bug 448260
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-3.4-r2
	virtual/os-headers
"

S="${WORKDIR}/${PN}-src-${PV}"

src_prepare() {
	default
	sed -i '/^docdir/,/^$/d' Makefile.am || die
	echo "guvcview/gui_qt5_audioctrls.cpp" >> po/POTFILES.skip || die # bug 630984
	eautoreconf
}

src_configure() {
	export MOC="$(qt5_get_bindir)/moc"

	# 599030
	tc-export CC CXX

	local myeconfargs=(
		--disable-debian-menu
		--disable-static
		$(use_enable gsl)
		$(use_enable pulseaudio pulse)
		$(use_enable qt5)
		$(use_enable !qt5 gtk3)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}
