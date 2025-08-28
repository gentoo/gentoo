# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'BC87A3FD0A54480F0BADBEBD21939FF0CA2A6567:aherbert:ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by commons.apache.org/rng"
HOMEPAGE="https://downloads.apache.org/commons/rng/"

KEYWORDS="amd64"
