# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	"83AAE47CE829A4146EF83420CA868D4C99149679:gnustep:ubuntu"
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by the GNUstep project"
HOMEPAGE="https://www.gnustep.org/"

KEYWORDS="~alpha amd64 ppc ~ppc64 ~sparc x86"
