# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE=gst-plugins-good
PYTHON_COMPAT=( python3_{11..13} )
inherit meson python-any-r1 xdg-utils

DESCRIPTION="Qt6 QML video sink plugin for GStreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"
SRC_URI="https://gstreamer.freedesktop.org/src/${GST_ORG_MODULE}/${GST_ORG_MODULE}-${PV}.tar.xz"
S="${WORKDIR}/${GST_ORG_MODULE}-${PV}"

LICENSE="GPL-2"
SLOT="1.0"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv ~x86"
IUSE="X"

RESTRICT="test"

DEPEND="
	dev-qt/qtbase:6=[gui,opengl,wayland,X?]
	dev-qt/qtdeclarative:6[opengl]
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[egl,opengl,wayland,X?]
"
RDEPEND="${DEPEND}
	>=dev-libs/glib-2.64.0:2
	>=media-libs/gstreamer-$(ver_cut 1-2):${SLOT}
	>=media-libs/${GST_ORG_MODULE}-${PV}:${SLOT}
"
RDEPEND+=" || ( >=dev-qt/qtbase-6.10:6[wayland] <dev-qt/qtwayland-6.10:6 )"
BDEPEND="${PYTHON_DEPS}
	app-arch/xz-utils
	dev-qt/qtbase:6
	dev-qt/qtshadertools:6
	virtual/perl-JSON-PP
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}/${P}-kamoso.patch" ) # in >=1.26.3, bug #958983

src_configure() {
	xdg_environment_reset
	local emesonargs=(
		$(meson_feature X qt-x11)
		-Dqt-egl=disabled
		-Dqt-wayland=enabled
		# disable all else:
		-Dalpha=disabled
		-Dapetag=disabled
		-Daudiofx=disabled
		-Daudioparsers=disabled
		-Dauparse=disabled
		-Dautodetect=disabled
		-Davi=disabled
		-Dcutter=disabled
		-Ddebugutils=disabled
		-Ddeinterlace=disabled
		-Ddtmf=disabled
		-Deffectv=disabled
		-Dequalizer=disabled
		-Dflv=disabled
		-Dflx=disabled
		-Dgoom=disabled
		-Dgoom2k1=disabled
		-Dicydemux=disabled
		-Did3demux=disabled
		-Dimagefreeze=disabled
		-Dinterleave=disabled
		-Disomp4=disabled
		-Dlaw=disabled
		-Dlevel=disabled
		-Dmatroska=disabled
		-Dmonoscope=disabled
		-Dmultifile=disabled
		-Dmultipart=disabled
		-Dreplaygain=disabled
		-Drtp=disabled
		-Drtpmanager=disabled
		-Drtsp=disabled
		-Dshapewipe=disabled
		-Dsmpte=disabled
		-Dspectrum=disabled
		-Dudp=disabled
		-Dvideobox=disabled
		-Dvideocrop=disabled
		-Dvideofilter=disabled
		-Dvideomixer=disabled
		-Dwavenc=disabled
		-Dwavparse=disabled
		-Dxingmux=disabled
		-Dy4m=disabled
		-Dadaptivedemux2=disabled
		-Daalib=disabled
		-Damrnb=disabled
		-Damrwbdec=disabled
		-Dbz2=disabled
		-Dcairo=disabled
		-Ddirectsound=disabled
		-Ddv=disabled
		-Ddv1394=disabled
		-Dflac=disabled
		-Dgdk-pixbuf=disabled
		-Dgtk3=disabled
		-Djack=disabled
		-Djpeg=disabled
		-Dlame=disabled
		-Dlibcaca=disabled
		-Dmpg123=disabled
		-Doss=disabled
		-Doss4=disabled
		-Dosxaudio=disabled
		-Dosxvideo=disabled
		-Dpng=disabled
		-Dpulse=disabled
		-Dshout2=disabled
		-Dspeex=disabled
		-Dtaglib=disabled
		-Dtwolame=disabled
		-Dvpx=disabled
		-Dwaveform=disabled
		-Dwavpack=disabled
		-Dqt5=disabled
		-Dqt6=enabled
		-Dsoup=disabled
		-Dv4l2=disabled
		-Dximagesrc=disabled
		-Dorc=disabled
		-Dexamples=disabled
		-Dpackage-name="Gentoo GStreamer ebuild"
		-Dpackage-origin="https://www.gentoo.org"
	)
	meson_src_configure
}

src_compile () {
	meson_src_compile ext/qt6/libgstqml6.so
}

src_install () {
	insinto /usr/$(get_libdir)/gstreamer-1.0
	doins "${BUILD_DIR}"/ext/qt6/libgstqml6.so
}
