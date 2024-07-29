# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP key for Github user akallabeth"
HOMEPAGE="https://github.com/akallabeth"
SRC_URI="https://github.com/akallabeth.gpg -> ${P}.asc"
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~loong ppc ppc64 ~riscv x86"

src_unpack() {
	:
}

src_install() {
	insinto /usr/share/openpgp-keys
	newins "${DISTDIR}/${P}.asc" akallabeth.asc
}
