# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'84789D24DF77A32433CE1F079EB80E92EB2135B1:sjaranowski:ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by maven.apache.org"
HOMEPAGE="https://downloads.apache.org/maven/"

LICENSE="public-domain"
KEYWORDS="amd64"
