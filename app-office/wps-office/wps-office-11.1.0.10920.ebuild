# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit unpacker xdg

MY_PV="$(ver_cut 4)"

DESCRIPTION="WPS Office is an office productivity suite"
HOMEPAGE="https://www.wps.com/office/linux/"

KEYWORDS="~amd64"

SRC_URI="https://wdl1.pcfg.cache.wpscdn.com/wpsdl/wpsoffice/download/linux/${MY_PV}/${PN}_${PV}.XA_amd64.deb"

SLOT="0"
RESTRICT="strip mirror" # mirror as explained at bug #547372
QA_PREBUILT="*"
LICENSE="WPS-EULA"
IUSE=""

# Deps got from this (listed in order):
# rpm -qpR wps-office-10.1.0.5707-1.a21.x86_64.rpm
# ldd /opt/kingsoft/wps-office/office6/wps
# ldd /opt/kingsoft/wps-office/office6/wpp
RDEPEND="
	app-arch/bzip2:0
	app-arch/xz-utils
	app-arch/lz4
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/libbsd
	|| ( dev-libs/libffi:0/7 dev-libs/libffi-compat:7 )
	dev-libs/libgcrypt:0
	dev-libs/libgpg-error
	dev-libs/libpcre:3
	dev-libs/nspr
	dev-libs/nss
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	media-libs/flac
	media-libs/libogg
	media-libs/libsndfile
	media-libs/libvorbis
	media-libs/libpng:0
	media-sound/pulseaudio
	net-libs/libasyncns
	net-print/cups
	sys-apps/attr
	sys-apps/util-linux
	sys-apps/dbus
	sys-apps/tcp-wrappers
	sys-libs/libcap
	sys-libs/zlib:0
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXau
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libXv
	x11-libs/libxcb
	dev-libs/libxslt
	x11-libs/pango
	virtual/glu
"
DEPEND=""
BDEPEND=""

S="${WORKDIR}"

src_install() {
	exeinto /usr/bin
	exeopts -m0755
	doexe "${S}"/usr/bin/*

	insinto /usr/share
	# Skip mime subdir to not get selected over rest of office suites
	doins -r "${S}"/usr/share/{applications,desktop-directories,icons,templates}

	insinto /opt/kingsoft/wps-office
	doins -r "${S}"/opt/kingsoft/wps-office/{office6,templates}

	fperms 0755 /opt/kingsoft/wps-office/office6/{et,wpp,wps,wpspdf}
}
