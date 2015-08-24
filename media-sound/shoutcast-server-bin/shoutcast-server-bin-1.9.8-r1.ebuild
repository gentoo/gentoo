# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils user

DESCRIPTION="SHOUTcast is a streaming audio system"
HOMEPAGE="http://www.shoutcast.com/license"
SRC_URI="sc_serv_${PV}_Linux.tar.gz"

LICENSE="shoutcast"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""

RDEPEND=""
DEPEND=""

QA_PRESTRIPPED=/opt/bin/sc_serv

RESTRICT="fetch"

S=${WORKDIR}

pkg_nofetch() {
	elog "Download ${A} from ${HOMEPAGE} and copy it to ${DISTDIR}."
}

pkg_setup() {
	enewuser shoutcast -1 -1 -1 nogroup
}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-sc_serv.conf.patch
}

src_install() {
	into /opt
	dobin sc_serv || die "dobin failed"

	newinitd "${FILESDIR}"/shoutcast.2 shoutcast || die "newinitd failed"
	dodir /opt/shoutcast/content

	insinto /etc/shoutcast
	doins sc_serv.conf || die "doins failed"

	dodoc README.TXT

	fowners -R shoutcast:nogroup /{etc,opt}/shoutcast || die "chown failed"
	fperms -R 700 /{etc,opt}/shoutcast || die "chmod failed"
}

pkg_postinst() {
	elog
	elog "To start shoutcast, use the init.d script by running"
	elog "/etc/init.d/shoutcast."
	elog
	elog "On demand content should be stored in /opt/shoutcast/content"
	elog "See http://forums.winamp.com/showthread.php?threadid=75736 for"
	elog "more information on setting up on demand content"
	elog
	elog "FAQ's can be found at:"
	elog "http://forums.winamp.com/showthread.php?threadid=75736 "
	elog "and can help you with server setup."
	elog
	elog "An Gentoo Linux shoutcast guide can be found at "
	elog "https://www.gentoo.org/doc/en/shoutcast-config.xml"
	elog
}
