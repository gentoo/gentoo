# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'70D2060738BEF80523ACAFF7D75C03B39B5E14E1:idk:manual'
	'2D3D2D03910C6504C1210C65EE60C0C8EE7256A8:zzz:manual'
)

inherit sec-keys

DESCRIPTION='OpenPGP keys used to sign I2P releases'
HOMEPAGE='https://i2p.net/en/docs/development/release-signing-key/'
SRC_URI+="
	https://i2p.net/idk.key.asc -> idk-${PV}.gpg
	https://i2p.net/zzz.key.asc -> zzz-${PV}.gpg
"

KEYWORDS='amd64 ~arm64'
