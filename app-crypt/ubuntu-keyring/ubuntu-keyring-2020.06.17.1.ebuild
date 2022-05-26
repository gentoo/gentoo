# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="GnuPG archive keys of the Ubuntu archive"
HOMEPAGE="https://packages.ubuntu.com/hirsute/ubuntu-keyring"
SRC_URI="mirror://ubuntu/pool/main/${PN:0:1}/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

DOCS=( changelog README )

src_install() {
	default
	insinto /usr/share/keyrings/
	doins keyrings/*.gpg
}
