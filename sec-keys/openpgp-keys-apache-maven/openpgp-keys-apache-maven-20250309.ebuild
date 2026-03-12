# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'88BE34F94BDB2B5357044E2E3A387D43964143E3:maven-bin:ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by maven.apache.org"
HOMEPAGE="https://maven.apache.org/download.cgi"

KEYWORDS="amd64"
