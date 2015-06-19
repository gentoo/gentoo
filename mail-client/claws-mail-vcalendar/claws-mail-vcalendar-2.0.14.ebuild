# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/claws-mail-vcalendar/claws-mail-vcalendar-2.0.14.ebuild,v 1.7 2013/05/08 04:06:40 fauli Exp $

EAPI=4

inherit eutils multilib

MY_P="${P#claws-mail-}"

DESCRIPTION="Plugin for Claws to support the vCalendar meeting format"
HOMEPAGE="http://www.claws-mail.org/"
SRC_URI="http://www.claws-mail.org/downloads/plugins/${MY_P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 ~sparc x86"
IUSE=""
RDEPEND="~mail-client/claws-mail-3.9.0
		>=net-misc/curl-7.9.7"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.0.13_password-disclosure.patch
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README

	# going to conflict with libical
	rm -f "${D}"/usr/include/ical.h
	# kill useless files
	rm -f "${D}"/usr/lib*/claws-mail/plugins/*.{a,la}
}
