# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'B1D2BD1375BECB784CF4F8C4D73CF638C53C06BE:jas:openpgp'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used for net-misc/inetutils"
HOMEPAGE="https://savannah.gnu.org/projects/inetutils/"
KEYWORDS="amd64"
