# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="GnuPG archive keys of the Ubuntu archive"
HOMEPAGE="http://packages.ubuntu.com/zesty/ubuntu-keyring"
SRC_URI="mirror://ubuntu/pool/main/${PN:0:1}/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"/${PN}-2018.01.17

src_install() {
	insinto /usr/share/keyrings/
	doins keyrings/*.gpg

	dodoc changelog README
}
