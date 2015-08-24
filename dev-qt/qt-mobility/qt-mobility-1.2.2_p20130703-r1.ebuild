# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib qt4-r2

DESCRIPTION="Additional Qt APIs for mobile devices and desktop platforms"
HOMEPAGE="http://doc-snapshots.qt.io/qt-mobility/index.html"
SRC_URI="https://dev.gentoo.org/~pesa/distfiles/${P}.tar.xz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"

QT_MOBILITY_MODULES=(connectivity +contacts feedback gallery location
		messaging multimedia organizer publishsubscribe
		sensors serviceframework systeminfo versit)
IUSE="bluetooth debug doc networkmanager pulseaudio qml +tools
	${QT_MOBILITY_MODULES[@]}"

REQUIRED_USE="
	|| ( ${QT_MOBILITY_MODULES[@]#[+-]} )
	versit? ( contacts )
"

RDEPEND="
	>=dev-qt/qtcore-4.8.0:4
	connectivity? (
		>=dev-qt/qtdbus-4.8.0:4
		bluetooth? ( net-wireless/bluez )
	)
	contacts? ( >=dev-qt/qtgui-4.8.0:4 )
	gallery? ( >=dev-qt/qtdbus-4.8.0:4 )
	location? (
		>=dev-qt/qtdeclarative-4.8.0:4
		>=dev-qt/qtgui-4.8.0:4
		>=dev-qt/qtsql-4.8.0:4[sqlite]
	)
	messaging? ( >=net-libs/qmf-4.0 )
	multimedia? (
		>=dev-qt/qtgui-4.8.0-r4:4[xv]
		>=dev-qt/qtopengl-4.8.0:4
		media-libs/alsa-lib
		media-libs/gstreamer:0.10
		media-libs/gst-plugins-bad:0.10
		media-libs/gst-plugins-base:0.10
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXv
		pulseaudio? ( media-sound/pulseaudio[alsa] )
	)
	publishsubscribe? (
		tools? ( >=dev-qt/qtgui-4.8.0:4 )
	)
	qml? ( >=dev-qt/qtdeclarative-4.8.0:4 )
	serviceframework? (
		>=dev-qt/qtdbus-4.8.0:4
		>=dev-qt/qtsql-4.8.0:4[sqlite]
		tools? ( >=dev-qt/qtgui-4.8.0:4 )
	)
	systeminfo? (
		>=dev-qt/qtdbus-4.8.0:4
		>=dev-qt/qtgui-4.8.0:4
		sys-apps/util-linux
		virtual/libudev:=
		x11-libs/libX11
		x11-libs/libXrandr
		bluetooth? ( net-wireless/bluez )
		networkmanager? ( net-misc/networkmanager )
	)
	versit? ( >=dev-qt/qtgui-4.8.0:4 )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( >=dev-qt/qthelp-4.8.0:4 )
	multimedia? (
		sys-kernel/linux-headers
		x11-proto/videoproto
	)
	systeminfo? ( sys-kernel/linux-headers )
"

src_prepare() {
	qt4-r2_src_prepare

	# disable building of code snippets in doc/
	# and translations (they aren't actually translated)
	sed -i -re '/SUBDIRS \+= (doc|translations)/d' qtmobility.pro || die

	# fix automagic dependency on qt-declarative
	if ! use qml; then
		sed -i -e '/SUBDIRS += declarative/d' plugins/plugins.pro || die
	fi
}

src_configure() {
	# figure out which modules to build
	local modules=
	for mod in "${QT_MOBILITY_MODULES[@]#[+-]}"; do
		use ${mod} && modules+="${mod} "
	done

	# custom configure script
	local myconf=(
		./configure
		-prefix "${EPREFIX}/usr"
		-headerdir "${EPREFIX}/usr/include/qt4"
		-libdir "${EPREFIX}/usr/$(get_libdir)/qt4"
		-plugindir "${EPREFIX}/usr/$(get_libdir)/qt4/plugins"
		$(use debug && echo -debug || echo -release)
		$(use doc || echo -no-docs)
		$(use tools || echo -no-tools)
		-modules "${modules}"
	)
	echo "${myconf[@]}"
	"${myconf[@]}" || die "configure failed"

	# fix automagic dependency on bluez
	if ! use bluetooth; then
		sed -i -e '/^bluez_enabled =/s:yes:no:' config.pri || die
	fi

	# fix automagic dependency on networkmanager
	if ! use networkmanager; then
		sed -i -e '/^networkmanager_enabled =/s:yes:no:' config.pri || die
	fi

	# fix automagic dependency on pulseaudio
	if ! use pulseaudio; then
		sed -i -e '/^pulseaudio_enabled =/s:yes:no:' config.pri || die
	fi

	eqmake4 -recursive
}

src_compile() {
	qt4-r2_src_compile

	use doc && emake docs
}

src_install() {
	qt4-r2_src_install

	if use doc; then
		dodoc -r doc/html
		dodoc doc/qch/qtmobility.qch
		docompress -x /usr/share/doc/${PF}/qtmobility.qch
	fi
}
