# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="GnuPG archive keys of the Ubuntu archive"
HOMEPAGE="https://packages.debian.org/sid/ubuntu-keyring"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}.orig.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

S="${WORKDIR}"/${PN}

DOCS=( changelog README )

src_install() {
	default
	insinto /usr/share/keyrings/
	doins keyrings/*.gpg
}
