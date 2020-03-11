# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit unpacker xdg

MY_PV="$(ver_cut 4)"

DESCRIPTION="WPS Office is an office productivity suite"
HOMEPAGE="http://www.wps.cn/product/wpslinux/ http://wps-community.org/"

KEYWORDS="~amd64"

SRC_URI="http://wdl1.pcfg.cache.wpscdn.com/wpsdl/wpsoffice/download/linux/${MY_PV}/${PN}_${PV}.XA_amd64.deb"

SLOT="0"
RESTRICT="strip mirror" # mirror as explained at bug #547372
LICENSE="WPS-EULA"
IUSE=""

# Deps got from this (listed in order):
# rpm -qpR wps-office-10.1.0.5707-1.a21.x86_64.rpm
# ldd /opt/kingsoft/wps-office/office6/wps
# ldd /opt/kingsoft/wps-office/office6/wpp
RDEPEND="
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libxcb
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	dev-libs/glib:2
	sys-libs/zlib:0
	net-print/cups
	media-libs/libpng-compat:1.2
	virtual/glu

	dev-libs/libpcre:3
	dev-libs/libffi
	media-sound/pulseaudio
	app-arch/bzip2:0
	media-libs/libpng:0
	dev-libs/expat
	sys-apps/util-linux
	dev-libs/libbsd
	x11-libs/libXau
	x11-libs/libXdmcp
	sys-apps/dbus
	x11-libs/libXtst
	sys-apps/tcp-wrappers
	media-libs/libsndfile
	net-libs/libasyncns
	dev-libs/libgcrypt:0
	app-arch/xz-utils
	app-arch/lz4
	sys-libs/libcap
	media-libs/flac
	media-libs/libogg
	media-libs/libvorbis
	dev-libs/libgpg-error
	sys-apps/attr
"
DEPEND=""
BDEPEND=""

S="${WORKDIR}"

src_install() {
	exeinto /usr/bin
	exeopts -m0755
	doexe "${S}"/usr/bin/*

	insinto /usr/share
	doins -r "${S}"/usr/share/{applications,desktop-directories,icons,mime,templates}

	insinto /opt/kingsoft/wps-office
	doins -r "${S}"/opt/kingsoft/wps-office/{office6,templates}

	fperms 0755 /opt/kingsoft/wps-office/office6/{et,wpp,wps,wpspdf}
}
