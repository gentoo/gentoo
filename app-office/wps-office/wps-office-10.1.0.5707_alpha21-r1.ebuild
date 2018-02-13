# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit font gnome2-utils unpacker versionator xdg

MY_PV="$(get_version_component_range 1-4)"
MY_V="$(get_version_component_range 5)"

if [ -z "$(get_version_component_range 6)" ]; then
	MY_SP=""
else
	MY_SP="$(get_version_component_range 6)"
fi

case ${PV} in
	*_alpha*)
		MY_BRANCH=${MY_V/alpha/a}
		;;
	*_beta*)
		MY_BRANCH=${MY_V/beta/b}
		;;
	*)
		die "Invalid value for \${PV}: ${PV}"
		;;
esac
MY_VV=${MY_PV}~${MY_BRANCH}${MY_SP}

DESCRIPTION="WPS Office is an office productivity suite"
HOMEPAGE="http://linux.wps.cn/ http://wps-community.org/"

KEYWORDS="~amd64 ~x86"

SRC_URI="
	x86? ( http://kdl.cc.ksosoft.com/wps-community/download/${MY_BRANCH}/${PN}_${MY_VV}_i386.deb )
	amd64? ( http://kdl.cc.ksosoft.com/wps-community/download/${MY_BRANCH}/${PN}_${MY_VV}_amd64.deb )
"

SLOT="0"
RESTRICT="strip mirror" # mirror as explained at bug #547372
LICENSE="WPS-EULA"
IUSE="+sharedfonts"

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
	sys-devel/gcc
	sys-libs/glibc
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	dev-libs/glib:2
	sys-libs/zlib:0
	net-print/cups
	media-libs/libpng:1.2
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
	sys-apps/systemd
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

S="${WORKDIR}"

src_install() {
	exeinto /usr/bin
	exeopts -m0755
	doexe "${S}"/usr/bin/wps
	doexe "${S}"/usr/bin/wpp
	doexe "${S}"/usr/bin/et

	if ! use sharedfonts; then
		insinto /opt/kingsoft/wps-office/office6/fonts
		doins -r "${S}"/usr/share/fonts/wps-office/*
		rm -rf "${S}"/usr/share/fonts || die
	fi

	insinto /usr
	doins -r "${S}"/usr/share

	insinto /
	doins -r "${S}"/opt
	fperms 0755 /opt/kingsoft/wps-office/office6/{wps,wpp,et}
}

pkg_preinst() {
	xdg_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	use sharedfonts && font_pkg_postinst
	xdg_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_icon_cache_update
}
