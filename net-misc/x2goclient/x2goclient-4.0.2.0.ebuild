# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/x2goclient/x2goclient-4.0.2.0.ebuild,v 1.4 2015/02/20 12:57:37 voyageur Exp $

EAPI=5
inherit eutils nsplugins qt4-r2

DESCRIPTION="The X2Go Qt client"
HOMEPAGE="http://www.x2go.org"
SRC_URI="http://code.x2go.org/releases/source/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="ldap nsplugin"

DEPEND=">=net-libs/libssh-0.6.0_rc1
	net-print/cups
	dev-qt/qtcore:4[ssl]
	dev-qt/qtgui:4
	dev-qt/qtsvg:4
	x11-libs/libXpm
	ldap? ( net-nds/openldap )"
RDEPEND="${DEPEND}
	net-misc/nx"

CLIENT_BUILD=${WORKDIR}/${P}.client_build
PLUGIN_BUILD=${WORKDIR}/${P}.plugin_build

src_prepare() {
	if ! use ldap; then
		sed -e "s/-lldap//" -i x2goclient.pro || die
		sed -e "s/#define USELDAP//" -i x2goclientconfig.h || die
	fi

	mkdir -p "${CLIENT_BUILD}"
	use nsplugin && mkdir -p "${PLUGIN_BUILD}"
}

src_configure() {
	cd "${CLIENT_BUILD}"
	eqmake4 "${S}"/x2goclient.pro

	if use nsplugin;
	then
		cd "${PLUGIN_BUILD}"
		X2GO_CLIENT_TARGET=plugin eqmake4 "${S}"/x2goclient.pro
	fi
}

src_compile() {
	cd "${CLIENT_BUILD}"
	qt4-r2_src_compile

	if use nsplugin;
	then
		cd "${PLUGIN_BUILD}"
		qt4-r2_src_compile
	fi
}

src_install() {
	dobin "${CLIENT_BUILD}"/${PN}

	insinto /usr/share/pixmaps/x2goclient
	doins -r icons/*

	domenu desktop/${PN}.desktop
	doman man/man?/*

	if use nsplugin;
	then
		# PLUGINS_DIR comes from nsplugins.eclass
		exeinto /usr/$(get_libdir)/${PLUGINS_DIR}
		doexe "${PLUGIN_BUILD}"/libx2goplugin.so
	fi

	emake DESTDIR="${D}" PREFIX=/usr install_pluginprovider
}
