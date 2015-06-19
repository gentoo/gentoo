# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/shoutcast-trans-bin/shoutcast-trans-bin-0.4.0-r1.ebuild,v 1.11 2014/08/10 21:11:58 slyfox Exp $

inherit eutils

SVER=${PV//./}

DESCRIPTION="A transcoder that provides a source for shoutcast-server-bin to stream from"
HOMEPAGE="http://www.shoutcast.com/"
SRC_URI="http://yp.shoutcast.com/downloads/sc_trans_posix_${SVER}.tgz"

LICENSE="shoutcast"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""

RDEPEND="media-sound/shoutcast-server-bin"

S=${WORKDIR}/sc_trans_${SVER}

RESTRICT="fetch"

pkg_nofetch() {
	einfo "Download sc_trans_posix_${SVER}.tgz from ${HOMEPAGE}."
	einfo "Last known working location is ${SRC_URI}."
}

src_install() {
	# install executable
	exeinto /opt/shoutcast
	doexe sc_trans_linux

	# install the init.d file
	doinitd "${FILESDIR}"/shoutcast_trans

	# install sample configuration file
	dodoc example.lst
	cp sc_trans.conf sc_trans.conf.example
	dodoc sc_trans.conf.example

	# install configuration file
	sed -e "s/LogFile=sc_trans\.log/LogFile=\/dev\/null/" -i sc_trans.conf
	# filter out some midly offensive stuff in the config file
	sed -e "s|^StreamTitle=.*|StreamTitle=Example Stream|" -i sc_trans.conf
	sed -e "s|^StreamURL=.*|StreamURL=http://examplestream.com/|" -i sc_trans.conf
	sed -e "s|^PlaylistFile=.*|PlaylistFile=/opt/shoutcast/playlists/example.lst|" -i sc_trans.conf
	insinto /etc/shoutcast
	doins sc_trans.conf

	# create a directory for playlists to be put
	keepdir /opt/shoutcast/playlists

	# Fix permissions - security bug #63551
	fperms 600 /etc/shoutcast/sc_trans.conf
}

pkg_postinst() {
	elog "Shoutcast-trans can be started via the init.d script provided."
	elog "start it with /etc/init.d/shoutcast_trans"
	elog
	elog "The configuration file is /etc/shoutcast/sc_trans.conf."
	elog "Please have a look at the playlist file setting."
	elog "A sample playlist file can be found under /usr/share/doc/$P."
	elog "It also contains instructions how to build a playlist."
	elog "A directory /opt/shoutcast/playlists has been created for storing playlists."
}
