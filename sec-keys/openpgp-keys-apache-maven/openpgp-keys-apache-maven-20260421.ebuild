# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'88BE34F94BDB2B5357044E2E3A387D43964143E3:maven-bin:ubuntu'
	'84789D24DF77A32433CE1F079EB80E92EB2135B1:maven-bin-3.9.15:ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by maven.apache.org"
HOMEPAGE="https://maven.apache.org/download.cgi"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64"
