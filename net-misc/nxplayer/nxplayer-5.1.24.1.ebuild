# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator wrapper

MY_P="nomachine-enterprise-client_$(get_version_component_range 1-3)_$(get_version_component_range 4)"

DESCRIPTION="Client for NoMachine remote servers"
HOMEPAGE="https://www.nomachine.com"
SRC_URI="amd64? ( http://download.nomachine.com/download/$(get_version_component_range 1-2)/Linux/${MY_P}_x86_64.tar.gz )
	x86? ( http://download.nomachine.com/download/$(get_version_component_range 1-2)/Linux/${MY_P}_i686.tar.gz )"
S="${WORKDIR}"/NX/etc/NX/player/packages

LICENSE="nomachine"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="strip"

RDEPEND="
	dev-libs/glib:2
	dev-libs/openssl:0
"

QA_PREBUILT="*"

src_install() {
	local NXROOT=/opt/NX

	#dodir /etc/NX/localhost
	#echo 'PlayerRoot = "'"${NXROOT}"'"' > ${D}/etc/NX/localhost/player.cfg

	dodir /opt
	tar xozf nxclient.tar.gz -C "${ED}"/opt
	tar xozf nxplayer.tar.gz -C "${ED}"/opt

	make_wrapper nxplayer ${NXROOT}/bin/nxplayer ${NXROOT} ${NXROOT}/lib /opt/bin
}
