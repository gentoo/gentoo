# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="nomachine-enterprise-client_$(ver_cut 1-3)_$(ver_cut 4)"

DESCRIPTION="Client for NoMachine remote servers"
HOMEPAGE="https://www.nomachine.com"
SRC_URI="amd64? ( http://download.nomachine.com/download/$(ver_cut 1-2)/Linux/${MY_P}_x86_64.tar.gz )
	x86? ( http://download.nomachine.com/download/$(ver_cut 1-2)/Linux/${MY_P}_i686.tar.gz )"
S="${WORKDIR}"/NX/etc/NX/player/packages

LICENSE="nomachine"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

RDEPEND="
	|| (
		sys-libs/libxcrypt[compat]
		sys-libs/glibc[crypt(-)]
	)
	dev-libs/glib:2
	dev-libs/openssl:0
"

QA_PREBUILT="*"

src_install() {
	dodir /opt
	tar xozf nxclient.tar.gz -C "${ED}"/opt || die
	tar xozf nxplayer.tar.gz -C "${ED}"/opt || die

	doenvd "${FILESDIR}"/50nxplayer
	dosym -r /opt/NX/bin/nxplayer /opt/bin/nxplayer
}
