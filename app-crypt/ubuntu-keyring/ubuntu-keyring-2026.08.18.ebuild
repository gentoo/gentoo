# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="GnuPG archive keys of the Ubuntu archive"
HOMEPAGE="https://packages.ubuntu.com/stonking/ubuntu-keyring"
SRC_URI="mirror://ubuntu/pool/main/u/${PN}/${PN}_${PV}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~loong ~ppc64 ~x86"

DOCS=( changelog README )

src_install() {
	default
	insinto /usr/share/keyrings/
	doins keyrings/*.gpg
}
