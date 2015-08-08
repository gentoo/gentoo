# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

MY_P="${P/plugin/plugins}"

DESCRIPTION="GOsa plugin for Samba integration"
HOMEPAGE="https://oss.gonicus.de/labs/gosa/wiki/WikiStart."
SRC_URI="ftp://oss.gonicus.de/pub/gosa/${MY_P}.tar.bz2
	http://oss.gonicus.de/pub/gosa/${MY_P}.tar.bz2
	ftp://oss.gonicus.de/pub/gosa/archive/${MY_P}.tar.bz2
	http://oss.gonicus.de/pub/gosa/archive/${MY_P}.tar.bz2	"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="~net-nds/gosa-core-${PV}
	~net-nds/gosa-plugin-systems-${PV}"

S="${WORKDIR}/${MY_P}"
GOSA_COMPONENT="${PN/gosa-plugin-}"

src_install() {
	insinto /usr/share/gosa/html/plugins/${GOSA_COMPONENT}/
	doins -r html/*

	insinto /usr/share/gosa/locale/plugins/${GOSA_COMPONENT}/
	doins -r locale/*

	insinto /usr/share/gosa/plugins
	doins -r admin personal

	insinto /usr/share/gosa/doc/plugins/${GOSA_COMPONENT}/
	doins -r help/*

	dodoc contrib/*
}

pkg_postinst() {
	ebegin "Updating class cache and locales"
	"${EROOT}"usr/sbin/update-gosa
	eend $?
}
