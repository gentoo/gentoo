# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Portmon is a network service monitoring daemon"
HOMEPAGE="http://aboleo.net/software/portmon/"
SRC_URI="http://aboleo.net/software/portmon/downloads/${P}.tar.gz"

KEYWORDS="~amd64 ~ppc x86"
SLOT="0"
LICENSE="GPL-2"

PATCHES=(
	"${FILESDIR}"/${P}-fno-common.patch
)

src_configure() {
	econf --sysconfdir=/etc/portmon
}

src_install() {
	into /usr
	dosbin src/portmon

	doman extras/portmon.8

	insinto /etc/portmon
	doins extras/portmon.hosts.sample
	dodoc AUTHORS BUGS README

	newinitd "${FILESDIR}"/portmon.init portmon
}
