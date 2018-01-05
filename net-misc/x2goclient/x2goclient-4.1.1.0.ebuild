# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils qmake-utils

DESCRIPTION="The X2Go Qt client"
HOMEPAGE="http://www.x2go.org"
SRC_URI="http://code.x2go.org/releases/source/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ldap"

COMMON_DEPEND="dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	>=net-libs/libssh-0.6.0_rc1
	net-print/cups
	x11-libs/libXpm
	ldap? ( net-nds/openldap )"
DEPEND="${COMMON_DEPEND}
	dev-qt/linguist-tools:5"
RDEPEND="${COMMON_DEPEND}
	net-misc/nx"

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

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
