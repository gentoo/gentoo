# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'6BFAB2E3C6490B421B25C76C9C8C892F91F8E6D1:pottlinger:ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by creadur.apache.org"
HOMEPAGE="https://creadur.apache.org"

KEYWORDS="amd64 arm64 ppc64"
