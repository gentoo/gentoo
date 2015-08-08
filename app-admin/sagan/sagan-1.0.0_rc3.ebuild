# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit eutils autotools-utils user

DESCRIPTION="Sagan is a multi-threaded, real time system and event log monitoring system"
HOMEPAGE="http://sagan.quadrantsec.com/"
SRC_URI="http://sagan.quadrantsec.com/download/sagan-1.0.0RC3.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="geoip +libdnet +lognorm mysql +pcap smtp snort"

RDEPEND="dev-libs/libpcre
	app-admin/sagan-rules[lognorm?]
	smtp? ( net-libs/libesmtp )
	pcap? ( net-libs/libpcap )
	mysql? ( virtual/mysql )
	lognorm? (
		dev-libs/liblognorm
		dev-libs/json-c
		dev-libs/libee
		dev-libs/libestr
			)
	libdnet? ( dev-libs/libdnet )
	snort? ( >=net-analyzer/snortsam-2.50 )
	geoip? ( dev-libs/geoip )
	"

DEPEND="virtual/pkgconfig
	${RDEPEND}"

DOCS=( AUTHORS ChangeLog FAQ INSTALL README NEWS TODO )
PATCHES=( "${FILESDIR}"/json_header_location.patch )
S="${WORKDIR}/sagan-1.0.0RC3/"

pkg_setup() {
	enewgroup sagan
	enewuser sagan -1 -1 /dev/null sagan
}

src_configure() {
	 local myeconfargs=(
		$(use_enable smtp esmtp)
		$(use_enable lognorm)
		$(use_enable libdnet)
		$(use_enable pcap libpcap)
		$(use_enable snort snortsam)
		$(use_enable geoip)
	)

	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	diropts -g sagan -o sagan -m 775

	dodir /var/log/sagan

	keepdir /var/log/sagan

	touch "${ED}"/var/log/sagan/sagan.log
	chown sagan.sagan "${ED}"/var/log/sagan/sagan.log

	newinitd "${FILESDIR}"/sagan.init-r1 sagan
	newconfd "${FILESDIR}"/sagan.confd sagan

	insinto /usr/share/doc/${PF}/examples
	doins -r extra/*
}

pkg_postinst() {
	if use smtp; then
		ewarn "You have enabled smtp use flag. If you plan on using Sagan with"
		ewarn "email, create valid writable home directory for user 'sagan'"
		ewarn "For security reasons it was created with /dev/null home directory"
	fi

	einfo "For configuration assistance see"
	einfo "http://wiki.quadrantsec.com/bin/view/Main/SaganHOWTO"
}
