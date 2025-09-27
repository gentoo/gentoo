# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'2DB4F1EF0FA761ECC4EA935C86FDC7E2A11262CB:ggregory:ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by commons.apache.org"
HOMEPAGE="https://commons.apache.org"

KEYWORDS="amd64 ~arm64 ~ppc64"
