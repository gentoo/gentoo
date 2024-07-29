# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop qmake-utils xdg

DESCRIPTION="The X2Go Qt client"
HOMEPAGE="https://wiki.x2go.org/doku.php"
SRC_URI="https://code.x2go.org/releases/source/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="ldap"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	>=net-libs/libssh-0.7.5-r2
	net-print/cups
	x11-libs/libXpm
	ldap? ( net-nds/openldap:= )"
RDEPEND="${DEPEND}
	net-misc/nx"
BDEPEND="dev-qt/linguist-tools:5"

CLIENT_BUILD="${WORKDIR}"/${P}.client_build
PLUGIN_BUILD="${WORKDIR}"/${P}.plugin_build

src_prepare() {
	default

	if ! use ldap; then
		sed -e "s/-lldap//" -i x2goclient.pro || die
		sed -e "s/#define USELDAP//" -i src/x2goclientconfig.h || die
	fi
}

src_configure() {
	eqmake5 "${S}"/x2goclient.pro
}

src_install() {
	dobin ${PN}

	local size
	for size in 16 32 48 64 128 ; do
		doicon -s ${size} res/img/icons/${size}x${size}/${PN}.png
	done
	newicon -s scalable res/img/icons/hildon/${PN}_hildon.svg ${PN}.svg

	insinto /usr/share/pixmaps
	doins res/img/icons/${PN}.xpm

	domenu desktop/${PN}.desktop
	doman man/man?/*
}
