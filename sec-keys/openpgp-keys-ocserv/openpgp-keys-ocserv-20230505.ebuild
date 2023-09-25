# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP key for ocserv"
HOMEPAGE="https://ocserv.gitlab.io/www/download.html"
SRC_URI="https://ocserv.gitlab.io/www/96865171.asc -> ocserv-${PV}.asc"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc64 ~riscv x86"

S=${WORKDIR}

src_unpack() {
	:
}

src_install() {
	insinto /usr/share/openpgp-keys
	newins "${DISTDIR}/ocserv-${PV}.asc" ocserv.asc
}
