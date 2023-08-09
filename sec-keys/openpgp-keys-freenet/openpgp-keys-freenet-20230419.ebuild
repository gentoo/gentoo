# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by freenetproject.org"
HOMEPAGE="https://freenetproject.org/pages/download.html"
SRC_URI="https://freenetproject.org/assets/keyring.gpg -> ${P}-keyring.gpg"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"

S="${WORKDIR}"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - freenetproject.org.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
