# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils versionator

MY_P="nomachine-enterprise-client_$(get_version_component_range 1-3)_$(get_version_component_range 4)"

DESCRIPTION="Client for NoMachine remote servers"
HOMEPAGE="http://www.nomachine.com"
SRC_URI="amd64? ( http://download.nomachine.com/download/$(get_version_component_range 1-2)/Linux/${MY_P}_x86_64.tar.gz )
	x86? ( http://download.nomachine.com/download/$(get_version_component_range 1-2)/Linux/${MY_P}_i686.tar.gz )"
LICENSE="nomachine"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="strip"

DEPEND=""
RDEPEND="dev-libs/glib:2
	dev-libs/openssl:0"

S=${WORKDIR}/NX/etc/NX/player/packages

QA_PREBUILT="*"

src_install()
{
	local NXROOT=/opt/NX

#	dodir /etc/NX/localhost
#	echo 'PlayerRoot = "'"${NXROOT}"'"' > ${D}/etc/NX/localhost/player.cfg

	dodir /opt
	tar xozf nxclient.tar.gz -C "${D}"/opt
	tar xozf nxplayer.tar.gz -C "${D}"/opt

	make_wrapper nxplayer ${NXROOT}/bin/nxplayer ${NXROOT} ${NXROOT}/lib /opt/bin
}
