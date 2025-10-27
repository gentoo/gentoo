# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'A602970FE1BF5C9C8A9491B97A3C9FE21DFDBF44:lehmi:ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by pdfbox.apache.org"
HOMEPAGE="https://pdfbox.apache.org"

KEYWORDS="amd64 arm64 ppc64"
