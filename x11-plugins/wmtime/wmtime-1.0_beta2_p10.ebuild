# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils toolchain-funcs versionator

MY_PV="$(get_version_component_range 1-2)"
MY_PL="$(get_version_component_range 3)"
MY_PL="${MY_PL/beta/b}"
MY_PV="${MY_PV}${MY_PL}"
MY_PL="$(get_version_component_range 4)"
MY_PL="${MY_PL/p/}"

IUSE=""

DESCRIPTION="applet which displays the date and time in a dockable tile"
SRC_URI="mirror://debian/pool/main/w/wmtime/wmtime_${MY_PV}.orig.tar.gz
	mirror://debian/pool/main/w/wmtime/wmtime_${MY_PV}-${MY_PL}.diff.gz"
HOMEPAGE="http://packages.qa.debian.org/w/wmtime.html"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto
	>=sys-apps/sed-4"

S=${WORKDIR}/${PN}-${MY_PV}.orig/${PN}

src_prepare() {
	cd "${WORKDIR}"

	# apply debian patch
	epatch ${PN}_${MY_PV}-${MY_PL}.diff

	# honour Gentoo LDFLAGS, bug #335799
	sed -i "s/-o wmtime/\$(LDFLAGS) -o wmtime/" "${S}/Makefile"
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install () {
	dobin wmtime
	doman wmtime.1

	cd ..
	dodoc BUGS CHANGES HINTS README TODO

	# install sample config file, too
	dodoc debian/wmtimerc
}
