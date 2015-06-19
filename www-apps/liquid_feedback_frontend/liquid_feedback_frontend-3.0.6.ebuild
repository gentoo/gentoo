# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/liquid_feedback_frontend/liquid_feedback_frontend-3.0.6.ebuild,v 1.1 2015/05/27 19:20:28 tupone Exp $

EAPI=4

inherit eutils toolchain-funcs

PN_F=${PN}
PV_F=v${PV}
MY_P=${PN}-v${PV}

DESCRIPTION="Internet platforms for proposition development and decision making"
HOMEPAGE="http://www.public-software-group.org/liquid_feedback"
SRC_URI="http://www.public-software-group.org/pub/projects/liquid_feedback/frontend/v${PV}/${MY_P}.tar.gz"

LICENSE="HPND CC-BY-2.5"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=www-apps/liquid_feedback_core-3.0.4"
DEPEND="www-apps/rocketwiki-lqfb
	www-servers/apache
	>=www-apps/webmcp-1.2.6
	${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_install() {
	dodoc "${FILESDIR}"/lqfb.example.com.conf
	dodoc "${FILESDIR}"/postinstall-en.txt

	insinto /var/lib/${PN}
	doins -r app db env model static tmp
	insinto /var/lib/${PN}/locale
	doins locale/*.lua

	insinto /etc/${PN}
	doins "${FILESDIR}"/myconfig.lua config/*
	dosym /etc/${PN} /var/lib/${PN}/config

	insinto /usr/share/${PN}
	doins "${FILESDIR}"/lqfb-apache.conf

	fowners apache:apache /var/lib/${PN}/tmp
}
