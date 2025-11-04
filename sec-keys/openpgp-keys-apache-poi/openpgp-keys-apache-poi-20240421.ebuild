# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'6BA4DA8B1C88A49428A29C3D0C69C1EF41181E13:pjfanning:ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by poi.apache.org"
HOMEPAGE="https://poi.apache.org/download.html"

KEYWORDS="amd64 arm64 ppc64"
