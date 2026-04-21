# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION='OpenPGP keys used to sign I2P releases'
HOMEPAGE='https://i2p.net/en/docs/development/release-signing-key/'
SRC_URI='
	https://i2p.net/idk.key.asc
'
S=${WORKDIR}

LICENSE='public-domain'
SLOT='0'
KEYWORDS='~amd64 ~arm64'

src_install() {
	insinto /usr/share/openpgp-keys
	newins "${DISTDIR}/idk.key.asc" i2p.asc
}
