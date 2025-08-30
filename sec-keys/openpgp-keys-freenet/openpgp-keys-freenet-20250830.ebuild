# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	# :manual fails with "Too many keys found. Suspicious keys: [...]"
	'B30C3D91069F81ECFEFED0B1B41A6047FD6C57F9:arne_bab:ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by freenetproject.org"
HOMEPAGE="https://www.hyphanet.org/pages/download.html"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~arm64"

src_install() {
	sec-keys_src_install
	mv "${ED}"/usr/share/openpgp-keys/freenet{,project.org}.asc || die
}
